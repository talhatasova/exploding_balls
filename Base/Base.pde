class BaseClass {
    float x, y, radius; // Circle center and radius

    // Constructor
    BaseClass(float x, float y, float radius) {
        this.x = x;
        this.y = y;
        this.radius = radius;
    }

    // Draw the base (circular border)
    void drawBase() {
        noFill();
        stroke(255);
        strokeWeight(2);
        circle(x, y, radius * 2);
    }
}
