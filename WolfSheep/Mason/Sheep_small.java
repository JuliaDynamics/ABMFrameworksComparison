import sim.engine.*;
import sim.field.continuous.*;
import sim.field.grid.IntGrid2D;
import sim.field.grid.SparseGrid2D;
import sim.util.*;

public class Sheep_small implements Steppable
    {
    public Int2D loc = new Int2D(0,0);
    public SparseGrid2D fieldSheeps;
    public IntGrid2D fieldGrass;
    public Wsg_small theWsg;
    public boolean dead = false;
    public int energy = 0;
    public Sheep_small(Int2D location) { loc = location; }
    
    public boolean isDead() { return dead; }
    public void setDead(boolean val) { dead = val; }
        
    public void step(SimState state)
        {     
        if (dead) return;

        final Wsg_small wsg = (Wsg_small)state;

        boolean moved = false;
        int x = loc.x;
        int y = loc.y;

        int xmin = (x>0) ? -1 : 0;
        int xmax = (x<Wsg_small.GRID_WIDTH-1) ? 1 : 0;
        int ymin = (y>0) ? -1 : 0;
        int ymax = (y<Wsg_small.GRID_HEIGHT-1) ? 1 : 0;

        //generate int between xmin and xmax
        int dx = x + wsg.random.nextInt((xmax-xmin) + 1) + xmin;
        int dy = y + wsg.random.nextInt((ymax-ymin) + 1) + ymin;
        Int2D new_loc = new Int2D(dx, dy);
        loc = new_loc;
        wsg.fieldSheeps.setObjectLocation(this, loc);

        //eat grass
        int g = wsg.fieldGrass.get(loc.x, loc.y);
        if (g >= 20) {
            wsg.fieldGrass.set(loc.x, loc.y, 0);
            //energy
            energy += 5;
        }

        energy -= 1;
        if (energy <= 0) {
            dead = true;
            //remove from schedule
            state.schedule.scheduleOnce(this);
            return;
        }

        //reproduce
        if (wsg.random.nextDouble() < 0.2) {
            //reproduce
            energy /= 2;
            Int2D location = new Int2D(loc.x, loc.y);
            Sheep_small s = new Sheep_small(location);
            s.energy = energy;
            wsg.fieldSheeps.setObjectLocation(s, loc);
            Schedule schedule = state.schedule;
            schedule.scheduleRepeating(s, 1, 1.0);
        }

    }

}