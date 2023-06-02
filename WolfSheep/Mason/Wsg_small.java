import sim.engine.*;
import sim.util.*;
import sim.field.grid.IntGrid2D;
import sim.field.grid.SparseGrid2D;

public class Wsg_small extends SimState
    {
    private static final long serialVersionUID = 1;
    public static final int GRID_HEIGHT = 1131;
    public static final int GRID_WIDTH = 1131;
    public SparseGrid2D fieldSheeps = new SparseGrid2D(GRID_WIDTH, GRID_HEIGHT);
    public SparseGrid2D fieldWolves = new SparseGrid2D(GRID_WIDTH, GRID_HEIGHT);
    public IntGrid2D fieldGrass = new IntGrid2D(GRID_WIDTH, GRID_HEIGHT);

    public int numWS = 100;
    public int numSheep = 60;
    public int numWolves = 40;

    /** Creates a Flockers simulation with the given random number seed. */
    public Wsg_small(long seed)
        {
        super(seed);
        }
    
    public void start()
        {
        super.start();

        for (int i = 0; i < GRID_WIDTH; i++) {
            for (int j = 0; j < GRID_HEIGHT; j++) {
                if (random.nextDouble() < 0.5) {
                    fieldGrass.set(i, j, random.nextInt(20));
                } else {
                    fieldGrass.set(i, j, 0);
                }
            }
        }

        // make a bunch of flockers and schedule 'em.  A few will be dead
        for(int x=0;x<numSheep;x++)
            {
            Int2D location = new Int2D(random.nextInt(GRID_WIDTH), random.nextInt(GRID_HEIGHT));
            Sheep_small sheep = new Sheep_small(location);
            sheep.fieldSheeps = fieldSheeps;
            sheep.fieldGrass = fieldGrass;
            sheep.theWsg = this;
            sheep.energy = random.nextInt(2*4);
            fieldSheeps.setObjectLocation(sheep, location.x, location.y);
            schedule.scheduleRepeating(sheep, 1, 1.0);
            }

        for(int x=0;x<numWolves;x++)
        {
            Int2D location = new Int2D(random.nextInt(GRID_WIDTH), random.nextInt(GRID_HEIGHT));
            Wolf_small wolf = new Wolf_small(location);
            wolf.fieldSheeps = fieldSheeps;
            wolf.fieldWolves = fieldWolves;
            wolf.theWsg = this;
            wolf.energy = random.nextInt(2*13);
            fieldWolves.setObjectLocation(wolf, location.x, location.y);
            schedule.scheduleRepeating(wolf, 2, 1.0);
        }

        schedule.scheduleRepeating(new Steppable()
            {
            public void step(SimState state) { fieldGrass.add(1);}
            }, 3, 1.0);
        }

    public static void main(String[] args)
        {
        doLoop(Wsg_small.class, args);
        System.exit(0);
        }    

    }