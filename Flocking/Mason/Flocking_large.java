import sim.engine.Steppable;
import sim.util.Bag;
import sim.util.Double2D;
import sim.field.continuous.Continuous2D;
import sim.engine.SimState;

public class Flocking_large extends SimState
{
    public Continuous2D flockers;
    public double width;
    public double height;
    public int numFlockers;
    public double cohesion;
    public double avoidance;
    public double consistency;
    public double momentum;
    public double neighborhood;

    public Flocking_large(final long seed) {
        super(seed);
        this.width = 150.0;
        this.height = 150.0;
        this.numFlockers = 400;
        this.neighborhood = 15.0;
        this.cohesion = 0.03;
        this.avoidance = 0.015;
        this.consistency = 0.05;
        this.momentum = 1.0;
    }

    public void start() {
        super.start();
        this.flockers = new Continuous2D(this.neighborhood / 1.5, this.width, this.height);
        //this.flockers = new Continuous2D(0.1, this.width, this.height); // For non-compartmental
        for (int x = 0; x < this.numFlockers; ++x) {
            final Double2D location = new Double2D(this.random.nextDouble() * this.width, this.random.nextDouble() * this.height);
            final Flocker_large flocker = new Flocker_large(location);
            this.flockers.setObjectLocation((Object)flocker, location);
            flocker.flockers = this.flockers;
            flocker.theFlock = this;
            this.schedule.scheduleRepeating((Steppable)flocker);
        }
    }

    public static void main(final String[] args) {
        doLoop((Class)Flocking_large.class, args);
        System.exit(0);
    }
}