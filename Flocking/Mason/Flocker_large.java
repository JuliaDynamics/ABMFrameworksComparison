import sim.engine.SimState;
import ec.util.MersenneTwisterFast;
import sim.util.Bag;
import sim.field.continuous.Continuous2D;
import sim.util.Double2D;
import sim.engine.Steppable;

public class Flocker_large implements Steppable
{
    public Double2D loc;
    public Double2D lastd;
    public Continuous2D flockers;
    public Flocking_large theFlock;
    
    public Flocker_large(final Double2D location) {
        this.loc = new Double2D(0.0, 0.0);
        this.lastd = new Double2D(0.0, 0.0);
        this.loc = location;
    }
    
    public Bag getNeighbors() {
        return this.flockers.getNeighborsWithinDistance(this.loc, this.theFlock.neighborhood, true);
    }
    
    public Double2D momentum() {
        return this.lastd;
    }
    
    public Double2D consistency(final Bag b, final Continuous2D flockers) {
        if (b == null || b.numObjs == 0) {
            return new Double2D(0.0, 0.0);
        }
        double x = 0.0;
        double y = 0.0;
        int i = 0;
        int count = 0;
        for (i = 0; i < b.numObjs; ++i) {
            final Flocker_large other = (Flocker_large)b.objs[i];
            final Double2D m = ((Flocker_large)b.objs[i]).momentum();
            ++count;
            x += m.x;
            y += m.y;
        }
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(x, y);
    }
    
    public Double2D cohesion(final Bag b, final Continuous2D flockers) {
        if (b == null || b.numObjs == 0) {
            return new Double2D(0.0, 0.0);
        }
        double x = 0.0;
        double y = 0.0;
        int count = 0;
        int i;
        Flocker_large other;
        double dx;
        double dy;
        for (i = 0, i = 0; i < b.numObjs; ++i) {
            other = (Flocker_large)b.objs[i];
            dx = flockers.tdx(this.loc.x, other.loc.x);
            dy = flockers.tdy(this.loc.y, other.loc.y);
            ++count;
            x += dx;
            y += dy;
        }
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(-x / 10.0, -y / 10.0);
    }
    
    public Double2D avoidance(final Bag b, final Continuous2D flockers) {
        if (b == null || b.numObjs == 0) {
            return new Double2D(0.0, 0.0);
        }
        double x = 0.0;
        double y = 0.0;
        int i = 0;
        int count = 0;
        for (i = 0; i < b.numObjs; ++i) {
            final Flocker_large other = (Flocker_large)b.objs[i];
            if (other != this) {
                final double dx = flockers.tdx(this.loc.x, other.loc.x);
                final double dy = flockers.tdy(this.loc.y, other.loc.y);
                final double lensquared = dx * dx + dy * dy;
                ++count;
                x += dx / (lensquared * lensquared + 1.0);
                y += dy / (lensquared * lensquared + 1.0);
            }
        }
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(400.0 * x, 400.0 * y);
    }
    
    public void step(final SimState state) {
        final Flocking_large flock = (Flocking_large)state;
        this.loc = flock.flockers.getObjectLocation((Object)this);
        final Bag b = this.getNeighbors();
        final Double2D avoid = this.avoidance(b, flock.flockers);
        final Double2D cohe = this.cohesion(b, flock.flockers);
        final Double2D cons = this.consistency(b, flock.flockers);
        final Double2D mome = this.momentum();
        double dx = flock.cohesion * cohe.x + flock.avoidance * avoid.x + flock.consistency * cons.x + flock.momentum * mome.x;
        double dy = flock.cohesion * cohe.y + flock.avoidance * avoid.y + flock.consistency * cons.y + flock.momentum * mome.y;
        final double dis = Math.sqrt(dx * dx + dy * dy);
        if (dis > 0.0) {
            dx = dx / dis;
            dy = dy / dis;
        }
        this.lastd = new Double2D(dx, dy);
        this.loc = new Double2D(flock.flockers.stx(this.loc.x + dx), flock.flockers.sty(this.loc.y + dy));
        flock.flockers.setObjectLocation((Object)this, this.loc);
    }
}


