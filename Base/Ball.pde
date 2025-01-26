import processing.sound.*;

class BallClass {
    float x, y, radius;  // Ball position and radius
    float vx, vy;        // Ball velocity
    color c;             // Ball color
    SoundFile collisionSound; // Sound file for collision

    // Constructor
    BallClass(float x, float y, float radius, color c, String soundFile, PApplet app) {
        this.x = x;
        this.y = y;
        this.radius = radius;
        this.vx = random(-2, 2); // Random horizontal velocity
        this.vy = random(2, 5);  // Random vertical velocity
        this.c = c;

        // Load the sound file
        collisionSound = new SoundFile(app, soundFile);
    }

    // Update ball's position
    void update(float gravity) {
        vy += gravity; // Apply gravity
        x += vx;       // Update horizontal position
        y += vy;       // Update vertical position
    }

    // Check collision with the circular border
    boolean checkCollision(BaseClass base) {
        // Calculate the distance from the ball's center to the circle's center
        float distToCenter = dist(x, y, base.x, base.y);

        // Check if the ball is outside the circle
        if (distToCenter > base.radius - radius) {
            // Play collision sound
            collisionSound.play();

            // Calculate the angle of the collision
            float angle = atan2(y - base.y, x - base.x);

            // Push the ball back inside the circle
            float overlap = distToCenter - (base.radius - radius);
            x -= overlap * cos(angle);
            y -= overlap * sin(angle);

            // Reflect the velocity
            float normalX = cos(angle);
            float normalY = sin(angle);
            float dotProduct = vx * normalX + vy * normalY;

            vx -= 2 * dotProduct * normalX;
            vy -= 2 * dotProduct * normalY;

            return true; // Collision occurred
        }
        return false; // No collision
    }

    // Draw the ball
    void drawBall() {
        fill(c);
        noStroke();
        circle(x, y, radius * 2);
    }
}
