import sim.engine.Steppable;
import sim.util.Int2D;
import sim.util.Interval;
import sim.util.Bag;
import sim.field.grid.IntGrid2D;
import sim.engine.SimState;

public class Schelling extends SimState
{
    public int gridHeight;
    public int gridWidth;
    public int neighborhood;
    public int threshold;
    public double redProbability;
    public double blueProbability;
    public double emptyProbability;
    public double unavailableProbability;
    public IntGrid2D neighbors;
    public Bag emptySpaces;
    
    public Schelling(final long seed) {
        this(seed, 50, 50);
    }
    
    public Schelling(final long seed, final int width, final int height) {
        super(seed);
        this.neighborhood = 1;
        this.threshold = 3;
        this.redProbability = 0.4;
        this.blueProbability = 0.4;
        this.emptyProbability = 0.2;
        this.unavailableProbability = 0.0;
        this.emptySpaces = new Bag();
        this.gridWidth = width;
        this.gridHeight = height;
        this.createGrids();
    }
    
    protected void createGrids() {
        this.emptySpaces.clear();
        this.neighbors = new IntGrid2D(this.gridWidth, this.gridHeight, 0);
        final int[][] g = this.neighbors.field;
        for (int x = 0; x < this.gridWidth; ++x) {
            for (int y = 0; y < this.gridHeight; ++y) {
                final double d = this.random.nextDouble();
                if (d < this.redProbability) {
                    g[x][y] = 2;
                }
                else if (d < this.redProbability + this.blueProbability) {
                    g[x][y] = 3;
                }
                else if (d < this.redProbability + this.blueProbability + this.emptyProbability) {
                    g[x][y] = 0;
                    this.emptySpaces.add((Object)new Int2D(x, y));
                }
                else {
                    g[x][y] = 1;
                }
            }
        }
    }
    
    public void start() {
        super.start();
        this.createGrids();
        for (int x = 0; x < this.gridWidth; ++x) {
            for (int y = 0; y < this.gridHeight; ++y) {
                this.schedule.scheduleRepeating((Steppable)new Agent(x, y));
            }
        }
    }
    
    public static void main(final String[] args) {
        doLoop((Class)Schelling.class, args);
        System.exit(0);
    }
}

