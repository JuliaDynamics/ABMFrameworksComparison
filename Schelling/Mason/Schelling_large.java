import sim.engine.Steppable;
import sim.util.Int2D;
import sim.util.Interval;
import sim.util.Bag;
import sim.field.grid.IntGrid2D;
import sim.engine.SimState;
import sim.engine.RandomSequence;

public class Schelling_large extends SimState
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
    
    public Schelling_large(final long seed) {
        this(seed, 100, 100);
    }
    
    public Schelling_large(final long seed, final int width, final int height) {
        super(seed);
        this.neighborhood = 2;
        this.threshold = 8;
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
        Steppable[] array_agents = new Steppable[10000];
        int count = 0;
        for (int x = 0; x < this.gridWidth; ++x) {
            for (int y = 0; y < this.gridHeight; ++y) {
                array_agents[count] = new Agent_large(x, y);
                ++count;
            }
        }
        this.schedule.scheduleRepeating(new RandomSequence(array_agents));
    }
    
    public static void main(final String[] args) {
        doLoop((Class)Schelling_large.class, args);
        System.exit(0);
    }
}

