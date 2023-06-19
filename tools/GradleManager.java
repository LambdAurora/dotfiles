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
			case "status" -> statusGradles();
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
			case "use" -> {
				if (args.length < 2) {
					System.err.println("Please provide a version to use.");
					help();
					return;
				}

				String version = args[1];
				use(version);
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
					* status - Lists existing Gradle installations and enabled one.
					* install <version> [--bin] - Installs the specified Gradle version.
					* uninstall <version> - Uninstalls the specified Gradle version.
					* use <version> - Set the default version to use for Gradle.
				""");
	}

	static Path getGradleRootPath() {
		return Paths.get("/opt/gradle").toAbsolutePath().normalize();
	}

	static void statusGradles() {
		try {
			var installations = getGradleInstallations();

			System.out.println("Available Gradle environments: ");
			installations.forEach(gradle -> {
				boolean isDefault = gradle.isDefault();
				String color = isDefault ? "\u001b[36;1m" : "";
				System.out.println("  " + color + gradle.fancyName() + (isDefault ? " (default)" : "") + "\u001b[0m");
			});
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

					System.out.printf("Downloading archive file... \u001b[36;1m%5.1f%%\u001b[0m\r", currentProgress);

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
			System.exit(1);
		}
	}

	static void use(String version) {
		try {
			var installation = getGradleInstallations().stream()
					.filter(gradle -> gradle.name().equals(version))
					.findFirst();

			if (installation.isEmpty()) {
				System.err.println("\u001b[31;1mCannot use " + version + " as default version because it does not exist.\u001b[0m");
				System.exit(1);
			}

			if (installation.get().isDefault()) {
				System.out.println("\u001b[33;1mGradle " + installation.get().fancyName() + " is already the default environment.\u001b[0m");
			}

			var defaultPath = getGradleRootPath().resolve("default");

			if (Files.isSymbolicLink(defaultPath)) {
				Files.delete(defaultPath);
			}

			Files.createSymbolicLink(defaultPath, installation.get().path());
			System.out.println("\u001b[32;1mGradle " + installation.get().fancyName() + " has been set as the default environment.\u001b[0m");
		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);
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
			throw new IOException("Entry is outside of the target directory: " + entry.getName());

		return destPath;
	}

	static List<Installation> getGradleInstallations() throws IOException {
		var root = getGradleRootPath();
		List<Installation> list = null;

		try (var stream = Files.list(root)) {
			list = stream.filter(path -> path.getFileName().toString().matches("^\\d\\.\\d(?:\\.\\d)?(-bin)?$"))
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

		public String fancyName() {
			return this.name + (this.bin ? " (bin)" : "");
		}

		public boolean isDefault() {
			Path defaultDistribution = getGradleRootPath().resolve("default");

			try {
				Path defaultPath = Files.readSymbolicLink(defaultDistribution).toAbsolutePath().normalize();
				return this.path.toAbsolutePath().normalize().equals(defaultPath);
			} catch (IOException e) {
				return false;
			}
		}
	}
}
