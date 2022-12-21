import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class GradleManager {
	static final String GRADLE_URL = "https://services.gradle.org/distributions/gradle-";
	static final int BLOCK_SIZE = 1024;

	public static void main(String[] args) {
		if (args.length == 0) {
			help();
			System.exit(1);
		}

		// Handle help stuff.
		for (var arg : args) {
			if (arg.equals("-h") || arg.equals("--help")) {
				help();
				return;
			}
		}

		String command = args[0].toLowerCase();

		switch (command) {
			case "help" -> help();
			case "list" -> listGradles();
			case "install" -> {
				if (args.length < 2) {
					System.err.println("Please provide a version to install.");
					help();
					return;
				}

				String version = args[1];
				boolean bin = args.length == 3 && args[2] == "--bin";

				install(version, bin);
			}
			case "uninstall" -> {
			}
		}
	}

	static void help() {
		System.out.println("""
				Gradle Manager:

				Usage:
					java GradleManager.java <command> [arguments]

				Commands:
					* help - Shows this help message.
					* list - Lists existing Gradle installations.
					* install <version> [--bin] - Installs the specified Gradle version.
					* uninstall <version> - Uninstalls the specified Gradle version.
					* use <version> - Set the default version to use for Gradle.
				""");
	}

	static Path getGradleRootPath() {
		return Paths.get("/opt/gradle").toAbsolutePath().normalize();
	}

	static void listGradles() {
		try {
			var installations = getGradleInstallations();

			System.out.println("Existing installations: " + 
					installations.stream()
						.map(gradle -> gradle.name + (gradle.bin ? " (bin)" : ""))
						.collect(Collectors.joining(", "))
			);
		} catch (IOException e) {
			System.err.println("Could not fetch Gradle installations.");
			e.printStackTrace();
		}
	}

	static void install(String version, boolean bin) {
		try {
			var installations = getGradleInstallations();

			if (installations.stream().anyMatch(gradle -> gradle.name.equals(version) && gradle.bin == bin)) {
				System.out.println("This version is already installed, nothing to do!");
				return;
			}
			
			System.out.println("Installing Gradle " + version + (bin ? " (bin only)" : "") + "...");

			var rootPath = getGradleRootPath();
			var zipName = version + (bin ? "-bin" : "-all") + ".zip";
			var zipPath = rootPath.resolve(zipName);
			var url = new URL(GRADLE_URL + zipName);
			var conn = (HttpURLConnection) url.openConnection();
			long downloadSize = conn.getContentLength();

			var data = new byte[BLOCK_SIZE];

			try (var is = new BufferedInputStream(conn.getInputStream());
					var os = new BufferedOutputStream(Files.newOutputStream(zipPath), BLOCK_SIZE)) {
				long downloadedSize = 0;
				int len = 0;

				while ((len = is.read(data, 0, BLOCK_SIZE)) >= 0) {
					downloadedSize += len;

					final float currentProgress = ((float) downloadedSize) / downloadSize * 100.f;

					System.out.printf("Downloading archive file... %5.1f%%\r", currentProgress);

					os.write(data, 0, len);
				}

				System.out.println();
			}

			System.out.println("Extracting...");

			var installationDir = rootPath.resolve(version + (bin ? "-bin" : ""));

			try (var zis = new ZipInputStream(Files.newInputStream(zipPath))) {
				var entry = zis.getNextEntry();


				while (entry != null) {
					var destPath = getExtractedPath(installationDir, entry);

					if (destPath != null) {
						if (entry.isDirectory()) {
							Files.createDirectories(destPath);
						} else {
							Files.createDirectories(destPath.getParent());

							try (var os = Files.newOutputStream(destPath)) {
								int len;

								while ((len = zis.read(data)) > 0) {
									os.write(data, 0, len);
								}
							}
						}
					}

					entry = zis.getNextEntry();
				}

				zis.closeEntry();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	static Path getExtractedPath(Path destDir, ZipEntry entry) throws IOException {
		var parts = entry.getName().split("/");
		if (parts.length == 1) return null;

		Path destPath = destDir;
		for (int i = 1; i < parts.length; i++) {
			destPath = destPath.resolve(parts[i]);
		}

		if (!destPath.toAbsolutePath().startsWith(destDir))
			throw new IOException("Entry is outside of the target directory: "+ entry.getName());

		return destPath;
	}

	static List<Installation> getGradleInstallations() throws IOException {
		var root = getGradleRootPath();
		List<Installation> list = null;

		try (var stream = Files.list(root)) {
			list = stream.filter(path -> path.getFileName().toString().matches("^\\d\\.\\d(-bin)?$"))
				.map(Installation::fromPath)
				.toList();
		}

		if (list == null) {
			list = Collections.emptyList();
		}

		return list;
	}

	record Installation(String name, Path path, boolean bin) {
		static Installation fromPath(Path path) {
			var fileName = path.getFileName().toString();
			boolean bin = fileName.endsWith("-bin");

			return new Installation(bin ? fileName.replaceAll("-bin$", "") : fileName, path, bin);
		}
	}
}
