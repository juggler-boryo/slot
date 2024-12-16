float VW = 640.0;
float VH = 480.0;

class SlotMachine {
    int[] numbers;
    float[] positions;
    boolean[] spinning;
    float[] spinSpeeds;
    float defaultSpinSpeed;
    float slotXSize;
    float slotYSize;
    
    SlotMachine() {
        numbers = new int[]{1, 2, 3, 4, 5, 6, 7, 8, 9};
        positions = new float[3];
        spinning = new boolean[]{true, true, true};
        spinSpeeds = new float[]{10, 10, 10};
        defaultSpinSpeed = 10;
        slotXSize = 333;
        slotYSize = 150;
        
        initializePositions();
    }
    
    void initializePositions() {
        for (int i = 0; i < 3; i++) {
            positions[i] = random(0, numbers.length * 100);
        }
    }
    
    void drawNumber(float x, float y, int num) {
        fill(0);
        textSize(80);
        textAlign(CENTER, CENTER);
        text(str(num), x, y);
    }
    
    void draw() {
        pushMatrix();
        translate(VW / 2 - slotXSize / 2, VH / 2 - slotYSize / 2);
        
        // Draw main slot rectangle
        fill(255);
        rect(0, 0, slotXSize, slotYSize, 25);
        
        // Draw dividing lines
        stroke(0);
        strokeWeight(2);
        line(slotXSize / 3, 0, slotXSize / 3, slotYSize);
        line(slotXSize / 3 * 2, 0, slotXSize / 3 * 2, slotYSize);
        
        // Draw numbers
        for (int i = 0; i < 3; i++) {
            updatePosition(i);
            drawSlotNumbers(i);
        }
        popMatrix();
        
        // Draw result
        String result = getSlotNumbers();
        if (result.length() > 0) {
            pushMatrix();
            resetMatrix();
            fill(0);
            textSize(40);
            textAlign(LEFT, TOP);
            text(result, 20, 20);
            popMatrix();
        }
    }
    
    void updatePosition(int index) {
        if (spinning[index]) {
            positions[index] += spinSpeeds[index];
            if (positions[index] >= numbers.length * 100) {
                positions[index] = 0;
            }
        }
    }
    
    void drawSlotNumbers(int index) {
        float currentPos = positions[index] / 100.0;
        int currentIndex = floor(currentPos) % numbers.length;
        int nextIndex = (currentIndex + 1) % numbers.length;
        
        float interpolation = currentPos - floor(currentPos);
        float y = lerp(slotYSize / 2, slotYSize / 2 + 100, interpolation);
        
        float xPos = slotXSize / 6 + (slotXSize / 3 * index);
        drawNumber(xPos, y - 100, numbers[currentIndex]);
        drawNumber(xPos, y, numbers[nextIndex]);
    }
    
    void handleKeyPress(char key) {
        if (key == '1') {
            stopReel(0);
        } else if (key == '2') {
            stopReel(1);
        } else if (key == '3') {
            stopReel(2);
        } else if (key == ' ') {
            resetSlots();
        }
    }
    
    void stopReel(int index) {
        spinning[index] = false;
        for (int i = 0; i < 3; i++) {
            if (i != index) {
                spinSpeeds[i] += 5;
            }
        }
    }
    
    void resetSlots() {
        for (int i = 0; i < 3; i++) {
            spinning[i] = true;
            spinSpeeds[i] = defaultSpinSpeed;
        }
    }
    
    String getSlotNumbers() {
        if (!spinning[0] && !spinning[1] && !spinning[2]) {
            int[] currentNumbers = new int[3];
            for (int i = 0; i < 3; i++) {
                float currentPos = positions[i] / 100.0;
                int currentIndex = floor(currentPos) % numbers.length;
                currentNumbers[i] = numbers[currentIndex];
            }
            return str(currentNumbers[0]) + str(currentNumbers[1]) + str(currentNumbers[2]);
        }
        return "";
    }
}

SlotMachine slotMachine;

void setup() {
    fullScreen();
    slotMachine = new SlotMachine();
}

void draw() {
    background(255);
    scale(width / VW, height / VH);
    slotMachine.draw();
}

void keyPressed() {
    slotMachine.handleKeyPress(key);
}
