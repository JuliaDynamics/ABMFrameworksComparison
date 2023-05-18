import sim.engine.Steppable;
import sim.util.Bag;
import sim.util.Double2D;
import sim.field.continuous.Continuous2D;
import sim.engine.SimState;

public class Flocking extends SimState
{
    public Continuous2D flockers;
    public double width;
    public double height;
    public int numFlockers;
    public double cohesion;
    public double avoidance;
    public double randomness;
    public double consistency;
    public double momentum;
    public double neighborhood;

    public Flocking(final long seed) {
        super(seed);
        this.width = 100.0; //
        this.height = 100.0; //
        this.numFlockers = 300; //
        this.cohesion = 0.03; //
        this.avoidance = 0.015; //
        this.randomness = 1.0; //
        this.consistency = 0.05; //
        this.momentum = 1.0; //
        this.deadFlockerProbability = 0.0; //
        this.neighborhood = 5.0; //
    }

    public void start() {
        super.start();
        this.flockers = new Continuous2D(this.neighborhood / 1.5, this.width, this.height);
        //this.flockers = new Continuous2D(0.1, this.width, this.height); // For non-compartmental
        for (int x = 0; x < this.numFlockers; ++x) {
            final Double2D location = new Double2D(this.random.nextDouble() * this.width, this.random.nextDouble() * this.height);
            final Flocker flocker = new Flocker(location);
            this.flockers.setObjectLocation((Object)flocker, location);
            flocker.flockers = this.flockers;
            flocker.theFlock = this;
            this.schedule.scheduleRepeating((Steppable)flocker);
        }
    }

    public static void main(final String[] args) {
        doLoop((Class)Flocking.class, args);
        System.exit(0);
    }
}
