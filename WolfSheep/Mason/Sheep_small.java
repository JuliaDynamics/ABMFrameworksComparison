import sim.engine.*;
import sim.field.continuous.*;
import sim.field.grid.IntGrid2D;
import sim.field.grid.SparseGrid2D;
import sim.util.*;
import ec.util.*;


public class Sheep_small implements Steppable
    {
    private static final long serialVersionUID = 1;

    public Int2D loc = new Int2D(0,0);
    public Int2D lastd = new Int2D(0,0);
    public SparseGrid2D fieldSheeps;
    public IntGrid2D fieldGrass;
    public Wsg_small theWsg;
    public boolean dead = false;
    public int energy = 0;
    public double mom = 0.5;
    public Sheep_small(Int2D location) { loc = location; }
    
    public boolean isDead() { return dead; }
    public void setDead(boolean val) { dead = val; }
        
    public void step(SimState state)
        {     
            
        if (dead) return;

        final Wsg_small wsg = (Wsg_small)state;

        MersenneTwisterFast random = new MersenneTwisterFast(1);

        boolean moved = false;
        int x = loc.x;
        int y = loc.y;

        if (random.nextDouble() < mom) {
            int xm = x + (x - lastd.x);
            int ym = y + (y - lastd.y);
            Int2D new_loc = new Int2D(xm, ym);
            if (xm > 0 && xm < Wsg_small.GRID_WIDTH - 1 && ym > 0 && ym < Wsg_small.GRID_HEIGHT - 1) {
                wsg.fieldSheeps.setObjectLocation(this, new_loc);
                loc = new_loc;
                lastd = new Int2D(x, y);
                moved = true;
            }
        }

        if (!moved) {
            int xmin = (x>0) ? -1 : 0;
            int xmax = (x<Wsg_small.GRID_WIDTH-1) ? 1 : 0;
            int ymin = (y>0) ? -1 : 0;
            int ymax = (y<Wsg_small.GRID_HEIGHT-1) ? 1 : 0;

            //generate int between xmin and xmax
            int dx = x + random.nextInt((xmax-xmin) + 1) + xmin;
            int dy = y + random.nextInt((ymax-ymin) + 1) + ymin;
            Int2D new_loc = new Int2D(dx, dy);
            loc = new_loc;
            lastd = new Int2D(x, y);
        }
        wsg.fieldSheeps.setObjectLocation(this, loc);

        //eat grass
        int g = wsg.fieldGrass.get(loc.x, loc.y);
        if (g >= 20) {
            wsg.fieldGrass.set(loc.x, loc.y, 0);
            //energy
            energy += 4;
        }

        energy -= 1;
        if (energy <= 0) {
            dead = true;
            //remove from schedule
            state.schedule.scheduleOnce(this);
            return;
        }

        //reproduce
        if (random.nextDouble() < 0.2) {
            //reproduce
            energy /= 2;
            Int2D location = new Int2D(random.nextInt(Wsg_small.GRID_WIDTH), random.nextInt(Wsg_small.GRID_HEIGHT));
            Sheep_small s = new Sheep_small(location);
            s.energy = energy;
            wsg.fieldSheeps.setObjectLocation(s, loc);
            Schedule schedule = state.schedule;
            schedule.scheduleRepeating(s);
        }

    }

}