
import java.nio.file.Files;
import java.nio.file.Path;

public class SmartITAgent {

    public static void main(String[] args) throws Exception {
        Path script = Path.of("Supervision-Parc.ps1")
                .toAbsolutePath();

        if (!Files.isRegularFile(script)) {
            System.err.println(
                "Fichier absent : " + script
            );
            return;
        }

        System.out.println("SMART IT AGENT");
        System.out.println("Supervision : Windows 11 + PC1 + PC2");
        System.out.println("Arret : Ctrl + C");

        Process moteur = new ProcessBuilder(
                "powershell.exe",
                "-NoProfile",
                "-ExecutionPolicy", "RemoteSigned",
                "-File", script.toString()
        )
                .directory(script.getParent().toFile())
                .inheritIO()
                .start();

        Runtime.getRuntime().addShutdownHook(
            new Thread(() -> {
                if (moteur.isAlive()) {
                    moteur.destroy();
                }
            })
        );

        int code = moteur.waitFor();

        System.out.println(
            "Supervision terminee. Code : " + code
        );
    }
}
