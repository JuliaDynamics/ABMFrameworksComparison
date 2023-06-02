import sim.engine.*;
import sim.field.continuous.*;
import sim.field.grid.IntGrid2D;
import sim.field.grid.SparseGrid2D;
import sim.util.*;

public class Wolf_large implements Steppable
    {
    public Int2D loc = new Int2D(0,0);
    public SparseGrid2D fieldWolves;
    public SparseGrid2D fieldSheeps;
    public Wsg_large theWsg;
    public boolean dead = false;
    public int energy = 0;
    public Wolf_large(Int2D location) { loc = location; }
    
    public boolean isDead() { return dead; }
    public void setDead(boolean val) { dead = val; }
    
    public void step(SimState state)
        {     
        if (dead) return;

        final Wsg_large wsg = (Wsg_large)state;
        
        int x = loc.x;
        int y = loc.y;
        int xmin = (x>0) ? -1 : 0;
        int xmax = (x<Wsg_large.GRID_WIDTH-1) ? 1 : 0;
        int ymin = (y>0) ? -1 : 0;
        int ymax = (y<Wsg_large.GRID_HEIGHT-1) ? 1 : 0;
        int dx = x + wsg.random.nextInt((xmax-xmin) + 1) + xmin;
        int dy = y + wsg.random.nextInt((ymax-ymin) + 1) + ymin;
        Int2D new_loc = new Int2D(dx, dy);
        loc = new_loc;
        wsg.fieldWolves.setObjectLocation(this, loc);
        
        Bag a = wsg.fieldSheeps.getObjectsAtLocation(loc.x, loc.y);
        Bag b = new Bag();

        if (a != null && a.numObjs > 0){
            for (int k = 0; k < a.numObjs; k++) {
                Sheep_large s = (Sheep_large) a.objs[k];
                if (s.isDead())
                {
                    b.add(s);
                }
            }
        }
        if (b != null && b.numObjs > 0){
            int q = wsg.random.nextInt(b.numObjs);
            Sheep_large s = (Sheep_large) b.objs[q];
            s.setDead(true);
            energy += 13;
        }

        energy -= 1;

        if (energy <= 0) {
            dead = true;
            state.schedule.scheduleOnce(this);
            return;
        }
        if (wsg.random.nextDouble() < 0.2) {
            energy /= 2;
            Int2D location = new Int2D(loc.x, loc.y);

            Wolf_large w = new Wolf_large(location);
            w.energy = energy;

            wsg.fieldWolves.setObjectLocation(w, location);
            Schedule schedule = state.schedule;
            schedule.scheduleRepeating(w, 2, 1.0);
        }

        }
 
    }