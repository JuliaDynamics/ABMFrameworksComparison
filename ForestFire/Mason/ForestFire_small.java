import sim.engine.*;
import sim.field.grid.*;
import sim.util.*;

public class ForestFire_small extends SimState
    {
    public double density = 0.7;
    public int gridHeight = 100;
    public int gridWidth = 100;

    public IntGrid2D myfield = new IntGrid2D(gridWidth, gridHeight);

    public static final int GREEN = 0;
    public static final int BURNING = 1;
    public static final int RED = 2;
    public static final int EMPTY = 3;

    public ForestFire_small(long seed)
        {
        super(seed);
        }

    protected void createGrids()
        {
        for(int x = 0; x < gridWidth; x++)
            for(int y = 0; y < gridHeight; y++) {
                if (random.nextDouble() < density) {
                    if (y == 0) {
                        myfield.set(x,y, BURNING);
                    } 
                    else {
                        myfield.set(x,y, GREEN);
                    }
                } 
                else {
                    myfield.set(x,y, EMPTY);
                }
            }
        }
    
    public void start() {
        super.start();
        
        createGrids();

        schedule.scheduleRepeating(new Steppable()
        {
        public void step(SimState state) {
            for (int i = 0; i < gridWidth; i++) {
                for (int j = 0; j < gridHeight; j++) {
                    int v = myfield.get(i,j);
                    if (v == GREEN) {
                        for (int k = i-1; k <= i+1; k++) {
                            for (int l = j-1; l <= j+1; l++) {
                                if (k >= 0 && k < gridWidth && l >= 0 && l < gridHeight
                                    && (k != i || l != j)) {
                                    if (myfield.get(k,l) == BURNING) {
                                        myfield.set(i,j, BURNING);
                                        break;
                                    }
                                }
                            }
                        }
                    } 
                    else if (v == BURNING) {
                        myfield.set(i,j,RED);
                    }
                }
                
            }
        }
        });  
    }
    
    public static void main(String[] args)
        {
        doLoop(ForestFire_small.class, args);
        System.exit(0);
        }    
    }
    