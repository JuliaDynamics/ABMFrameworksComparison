import sim.engine.SimState;
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
    
    public Flocker_large(final Double2D location, final Double2D lastd) {
        this.lastd = lastd;
        this.loc = location;
    }
    
    public Bag getNeighbors() {
        return this.flockers.getNeighborsWithinDistance(this.loc, this.theFlock.neighborhood, true);
    }
    
    public Double2D momentum() {
        return this.lastd;
    }
    
    public Double2D consistency(final Bag b, final Continuous2D flockers) {
        double x = 0.0;
        double y = 0.0;
        int i = 0;
        int count = 0;
        for (i = 0; i < b.numObjs; ++i) {
            final Flocker_large other = (Flocker_large)b.objs[i];
            if (other != this) {
                final Double2D m = ((Flocker_large)b.objs[i]).momentum();
                x += m.x;
                y += m.y;
                ++count;
            }
        }
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(x, y);
    }
    
    public Double2D cohesion(final Bag b, final Continuous2D flockers) {
        double x = 0.0;
        double y = 0.0;
        int count = 0;
        int i;
        Flocker_large other;
        double dx;
        double dy;
        for (i = 0; i < b.numObjs; ++i) {
            other = (Flocker_large)b.objs[i];
            if (other != this) {
                dx = this.loc.x - other.loc.x;
                dy = this.loc.y - other.loc.y;
                x += dx;
                y += dy;
                ++count;
            }
        }
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(x, y);
    }
    
    public Double2D avoidance(final Bag b, final Continuous2D flockers) {
        double x = 0.0;
        double y = 0.0;
        int i = 0;
        int count = 0;
        for (i = 0; i < b.numObjs; ++i) {
            final Flocker_large other = (Flocker_large)b.objs[i];
            if (other != this) {
                final double dx = this.loc.x - other.loc.x;
                final double dy = this.loc.y - other.loc.y;
                final double lensquared = dx * dx + dy * dy;
                ++count;
                if (lensquared < 1.0) {
                    x -= dx;
                    y -= dy;
                }
            }
        }
        //System.out.println(count);
        if (count > 0) {
            x /= count;
            y /= count;
        }
        return new Double2D(x, y);
    }
    
    public void step(final SimState state) {
        final Flocking_large flock = (Flocking_large)state;
        this.loc = flock.flockers.getObjectLocation((Object)this);
        final Bag b = this.getNeighbors();
        final Double2D avoid = this.avoidance(b, flock.flockers);
        final Double2D cohe = this.cohesion(b, flock.flockers);
        final Double2D cons = this.consistency(b, flock.flockers);
        final Double2D mome = this.momentum();
        double dx = flock.cohesion * cohe.x + flock.avoidance * avoid.x + flock.consistency * cons.x + mome.x;
        double dy = flock.cohesion * cohe.y + flock.avoidance * avoid.y + flock.consistency * cons.y + mome.y;
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
