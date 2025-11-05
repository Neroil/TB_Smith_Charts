package org.openjfx;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.stage.Stage;
import javafx.scene.layout.Pane;
import javafx.scene.shape.Line;
import javafx.scene.text.Text;

public class CirclePointsDemo extends Application {
    // Utilitaire pour calculer les coordonnées Smith Chart
    private double[] smithCoord(double re, double im, double centerX, double centerY, double radius) {
        double denom = (re + 1) * (re + 1) + im * im;
        double rhoRe = (re * re + im * im - 1) / denom;
        double rhoIm = (2 * im) / denom;
        double px = centerX + radius * rhoRe;
        double py = centerY - radius * rhoIm;
        return new double[]{px, py};
    }

    @Override
    public void start(Stage stage) {
        Pane pane = new Pane();
        pane.setPrefSize(600, 600);

        // Zone d'affichage des infos dynamiques
        Text infoText = new Text(10, 580, "");
        infoText.setFill(Color.DARKGREEN);
        infoText.setStyle("-fx-font-size: 16px;");
        pane.getChildren().add(infoText);

        // Redraw function
        Runnable drawSmithCharts = () -> {
            pane.getChildren().clear();
            double w = pane.getWidth();
            double h = pane.getHeight();
            double radius = 0.4 * Math.min(w, h);
            double centerX = w / 2;
            double centerY = h / 2;

            // Cercle extérieur (|rho|=1)
            Circle outer = new Circle(centerX, centerY, radius);
            outer.setStroke(Color.BLACK);
            outer.setFill(Color.TRANSPARENT);
            outer.setStrokeWidth(2);
            pane.getChildren().add(outer);

            // Axe horizontal
            Line axis = new Line(centerX - radius, centerY, centerX + radius, centerY);
            axis.setStroke(Color.GRAY);
            axis.setOpacity(0.5);
            pane.getChildren().add(axis);

    
            // Titre
            Text title = new Text(centerX - 120, 40, "Abaque de Smith & Admittance");
            title.setFill(Color.BLACK);
            title.setStyle("-fx-font-size: 20px;");
            pane.getChildren().add(title);

            // --- Tracés Smith : cercles de résistance et arcs de réactance (impédance, rouge) ---
            double[] paramR = {0, 0.2, 0.5, 1, 2, 5};
            double[] paramX = {-5, -2, -1, -0.5, -0.2, 0, 0.2, 0.5, 1, 2, 5};
            int N = 500;
            // Cercles de résistance constante (impédance)
            for (double r : paramR) {
                javafx.scene.shape.Polyline poly = new javafx.scene.shape.Polyline();
                for (int i = 0; i < N / 2; i++) {
                    double x = 0.01 * Math.pow(10000, (double)i / (N / 2 - 1));
                    double[] pt = smithCoord(r, x, centerX, centerY, radius);
                    poly.getPoints().addAll(pt[0], pt[1]);
                }
                for (int i = N / 2 - 1; i >= 0; i--) {
                    double x = -0.01 * Math.pow(10000, (double)i / (N / 2 - 1));
                    double[] pt = smithCoord(r, x, centerX, centerY, radius);
                    poly.getPoints().addAll(pt[0], pt[1]);
                }
                poly.setStroke(Color.RED);
    if (Math.abs(r - 1.0) < 1e-6) {
        poly.setStrokeWidth(2.0); 
        poly.setOpacity(1);
    } else {
        poly.setStrokeWidth(0.8);
         poly.setOpacity(0.8);
    }
    poly.setFill(Color.TRANSPARENT);
    pane.getChildren().add(poly);
            }
            // Arcs de réactance constante (impédance)
            for (double x : paramX) {
                javafx.scene.shape.Polyline poly = new javafx.scene.shape.Polyline();
                for (int i = 0; i < N; i++) {
                    double r = 0.01 * Math.pow(10000, (double)i / (N - 1));
                    double[] pt = smithCoord(r, x, centerX, centerY, radius);
                    poly.getPoints().addAll(pt[0], pt[1]);
                }
                poly.setStroke(Color.RED);
                poly.setStrokeWidth(0.8);
                 poly.setOpacity(0.8);
                poly.setFill(Color.TRANSPARENT);
                pane.getChildren().add(poly);
            }

            // Cercles de conductance constante (admittance)
            for (double g : paramR) {
                javafx.scene.shape.Polyline poly = new javafx.scene.shape.Polyline();
                for (int i = 0; i < N / 2; i++) {
                    double b = 0.01 * Math.pow(10000, (double)i / (N / 2 - 1));
                    double[] ptZ = smithCoord(g, b, centerX, centerY, radius);
                    double px = 2 * centerX - ptZ[0];
                    double py = 2 * centerY - ptZ[1];
                    poly.getPoints().addAll(px, py);
                }
                for (int i = N / 2 - 1; i >= 0; i--) {
                    double b = -0.01 * Math.pow(10000, (double)i / (N / 2 - 1));
                    double[] ptZ = smithCoord(g, b, centerX, centerY, radius);
                    double px = 2 * centerX - ptZ[0];
                    double py = 2 * centerY - ptZ[1];
                    poly.getPoints().addAll(px, py);
                }
                poly.setStroke(Color.BLUE);
                poly.setStrokeWidth(1.2);
                poly.setFill(Color.TRANSPARENT);
                poly.setOpacity(0.5);
                pane.getChildren().add(poly);
                // labels supprimés
            }
            // Arcs de susceptance constante (admittance)
            for (double b : paramX) {
                javafx.scene.shape.Polyline poly = new javafx.scene.shape.Polyline();
                for (int i = 0; i < N; i++) {
                    double g = 0.01 * Math.pow(10000, (double)i / (N - 1));
                    double[] ptZ = smithCoord(g, b, centerX, centerY, radius);
                    double px = 2 * centerX - ptZ[0];
                    double py = 2 * centerY - ptZ[1];
                    poly.getPoints().addAll(px, py);
                }
                poly.setStroke(Color.BLUE);
                poly.setStrokeWidth(1.2);
                poly.setFill(Color.TRANSPARENT);
                poly.setOpacity(0.5);
                pane.getChildren().add(poly);
                // labels supprimés
            }
            // --- Fin tracés Smith et Admittance ---

            // Réaffiche le texte d'infos
            pane.getChildren().add(infoText);
        };

        // Listeners pour redimensionnement
        pane.widthProperty().addListener((obs, oldVal, newVal) -> drawSmithCharts.run());
        pane.heightProperty().addListener((obs, oldVal, newVal) -> drawSmithCharts.run());

        // Gestion du mouvement de la souris
        pane.setOnMouseMoved(e -> {
            double w = pane.getWidth();
            double h = pane.getHeight();
            double radius = 0.4 * Math.min(w, h);
            double centerX = w / 2;
            double centerY = h / 2;
            double px = e.getX();
            double py = e.getY();

            // Coordonnées Smith inverses (approximation)
            double rhoRe = (px - centerX) / radius;
            double rhoIm = (centerY - py) / radius;
            double rho = Math.sqrt(rhoRe * rhoRe + rhoIm * rhoIm);
            double phi = Math.atan2(rhoIm, rhoRe);

            // Impédance normalisée (r, x) à partir de rho
            double denom = (1 - rhoRe) * (1 - rhoRe) + rhoIm * rhoIm;
            double r = (1 - rhoRe * rhoRe - rhoIm * rhoIm) / denom;
            double x = (2 * rhoIm) / denom;

            // VSWR
            double vswr = (1 + rho) / (1 - rho);
            // Return Loss (dB)
            double rl = -20 * Math.log10(rho);
            // Q (qualité, ici |x/r|)
            double q = Math.abs(x / r);
            // Réflexion (module et phase)
            double reflection = rho;
            double reflectionPhase = Math.toDegrees(phi);

            // Affichage
            String txt = String.format(
                "r=%.2f, x=%.2f | rho=%.2f (%.1f°) | VSWR=%.2f | RL=%.2f dB | Q=%.2f",
                r, x, reflection, reflectionPhase, vswr, rl, q
            );
            infoText.setText(txt);
        });

        Scene scene = new Scene(pane, 600, 600);
        stage.setTitle("Abaque de Smith");
        stage.setScene(scene);
        stage.show();

        // Premier affichage
        drawSmithCharts.run();
    }

    public static void main(String[] args) {
        launch(args);
    }
}