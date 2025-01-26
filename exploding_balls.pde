import processing.sound.*;

BaseClass base; // The outer circle
ArrayList<BallClass> balls; // List of all balls
float gravity = 0.1;        // Gravity strength
ArrayList<Integer> ballCountHistory; // To store the history of ball counts
int maxY = 10; // Maximum number of balls for scaling the graph
int baseRadius = 200;
int ballRadius = 3;
boolean baseVisible = true; // To track whether the base is visible

void setup() {
    size(540, 480);

    // Create the stationary circle (base)
    base = new BaseClass(width / 2, height / 2, baseRadius); // Centered circle with specified radius

    // Initialize the ball list
    balls = new ArrayList<>();
    balls.add(new BallClass(base.x, base.y - baseRadius + ballRadius, ballRadius, color(255, 0, 0), "collision.mp3", this)); // Initial red ball

    // Initialize ball count history
    ballCountHistory = new ArrayList<>();
}

void draw() {
    // Semi-transparent overlay for a smoother visual effect
    fill(0, 20); // Dark overlay with slight transparency
    rect(0, 0, width, height);

    // Draw the base if it's visible
    if (baseVisible) {
        base.drawBase();
    }

    // Update and draw balls
    for (int i = balls.size() - 1; i >= 0; i--) {
        BallClass ball = balls.get(i);

        // Update the ball's position
        ball.update(gravity);

        // Check for collision only if the base is visible
        if (baseVisible && ball.checkCollision(base)) {
            // Spawn a new ball at the top of the circle
            balls.add(new BallClass(base.x, base.y - baseRadius + ballRadius, ballRadius, color(random(255), random(255), random(255)), "collision.mp3", this));
            createParticles(ball.x, ball.y); // Add particle burst effect
        }

        // Draw the ball
        ball.drawBall();
    }

    // Add the current number of balls to the history
    ballCountHistory.add(balls.size());
    if (ballCountHistory.size() > width) {
        // Limit the history size to the screen width
        ballCountHistory.remove(0);
    }

    // Dynamically update the maxY value to keep the graph in bounds
    if (balls.size() > maxY) {
        maxY = balls.size(); // Adjust the maximum y-axis tick dynamically
    }

    // Draw the X-Y coordinate plane and graph
    //drawXYPlane();
    //drawGraph();

    // Display the number of balls
    displayBallCount();
}

// Function to toggle the base's visibility
void toggleBase() {
    baseVisible = !baseVisible; // Toggle the visibility
}

// Handle keyboard input
void keyPressed() {
    if (key == ' ') { // Spacebar toggles the base's visibility
        toggleBase();
    }
}

// Function to draw the X-Y coordinate plane
void drawXYPlane() {
    stroke(255);
    strokeWeight(1);

    // Draw the X-axis
    line(50, height - 50, width - 50, height - 50);

    // Draw the Y-axis
    line(50, height - 50, 50, 50);

    // Draw Y-axis ticks dynamically
    int numTicks = 5; // Number of ticks on the Y-axis
    for (int i = 0; i <= numTicks; i++) {
        float y = map(i, 0, numTicks, height - 50, 50); // Map the ticks to screen space
        float label = map(i, 0, numTicks, 0, maxY);     // Scale the label to the maxY value

        // Draw the tick line and label
        line(45, y, 50, y);
        fill(255);
        noStroke();
        textSize(12);
        textAlign(RIGHT, CENTER);
        text(int(label), 40, y);
    }

    // Label the axes
    fill(255);
    textSize(14);
    textAlign(CENTER);
    text("Time", width / 2, height - 20);
    textAlign(RIGHT, CENTER);
}

// Function to draw the graph of ball count
void drawGraph() {
    stroke(0, 255, 0); // Green line for the graph
    strokeWeight(2);
    noFill();

    // Start plotting the graph
    beginShape();
    for (int i = 0; i < ballCountHistory.size(); i++) {
        float x = map(i, 0, ballCountHistory.size(), 50, width - 50); // Map to graph width
        float y = map(ballCountHistory.get(i), 0, maxY, height - 50, 50); // Map to graph height
        vertex(x, y);
    }
    endShape();

    // Highlight the last point
    if (!ballCountHistory.isEmpty()) {
        float lastX = map(ballCountHistory.size() - 1, 0, ballCountHistory.size(), 50, width - 50);
        float lastY = map(ballCountHistory.get(ballCountHistory.size() - 1), 0, maxY, height - 50, 50);
        fill(0, 255, 0);
        noStroke();
        ellipse(lastX, lastY, 8, 8); // Draw a small circle at the last point
    }
}

// Function to display the number of balls explicitly
void displayBallCount() {
    fill(255);
    textSize(16);
    textAlign(LEFT);
    text("Number of Balls: " + balls.size(), 60, 30);
}

// Function to create particle bursts on collision
void createParticles(float x, float y) {
    for (int i = 0; i < 10; i++) {
        float angle = random(TWO_PI);
        float speed = random(1, 3);
        float px = x + cos(angle) * speed;
        float py = y + sin(angle) * speed;

        stroke(random(200, 255), random(100, 200), random(100, 255));
        strokeWeight(random(1, 3));
        point(px, py); // Draw particles
    }
}
