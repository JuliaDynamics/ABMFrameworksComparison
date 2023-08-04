import sim.engine.Steppable;
import sim.util.Int2D;
import sim.util.Bag;
import sim.field.grid.ObjectGrid2D;
import sim.engine.SimState;
import sim.engine.RandomSequence;

public class Schelling_small extends SimState
{
    public int gridHeight;
    public int gridWidth;
    public int neighborhood;
    public int threshold;
    public double redProbability;
    public double blueProbability;
    public double emptyProbability;
    public double unavailableProbability;
    public ObjectGrid2D neighbors;
    public Bag emptySpaces;
    public Bag fillSpaces;
    
    public Schelling_small(final long seed) {
        this(seed, 100, 100);
    }
    
    public Schelling_small(final long seed, final int width, final int height) {
        super(seed);
        this.neighborhood = 2;
        this.threshold = 8;
        this.redProbability = 0.4;
        this.blueProbability = 0.4;
        this.emptyProbability = 0.2;
        this.emptySpaces = new Bag();
        this.fillSpaces = new Bag();
        this.gridWidth = width;
        this.gridHeight = height;
    }
        
    public void start() {
        super.start();
        for (int x = 0; x < this.gridWidth; ++x) {
            for (int y = 0; y < this.gridHeight; ++y) {
                final double d = this.random.nextDouble();
                if (d < this.redProbability + this.blueProbability) {
                    this.fillSpaces.add((Object)new Int2D(x, y));
                }
                else {
                    this.emptySpaces.add((Object)new Int2D(x, y));
                }
            }
        }

        this.neighbors = new ObjectGrid2D(this.gridWidth, this.gridHeight);

        Steppable[] array_agents = new Steppable[this.fillSpaces.numObjs];
        int count = 0;

        for (int i = 0; i < this.fillSpaces.numObjs; ++i) {
            double d = this.random.nextDouble();
            Int2D pos = (Int2D)this.fillSpaces.objs[i];
            if (d < 0.5) {
                Agent_small agent = new Agent_small(pos.x, pos.y, 1, false);
                this.neighbors.field[pos.x][pos.y] = agent;
                array_agents[count] = agent;
            }
            else {
                Agent_small agent = new Agent_small(pos.x, pos.y, 2, false);
                this.neighbors.field[pos.x][pos.y] = agent;
                array_agents[count] = agent;
            }
            ++count;
        }

        this.schedule.scheduleRepeating(new RandomSequence(array_agents));
    }
    
    public static void main(final String[] args) {
        doLoop((Class)Schelling_small.class, args);
        System.exit(0);
    }
}

