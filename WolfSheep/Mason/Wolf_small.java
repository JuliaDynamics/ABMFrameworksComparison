import sim.engine.*;
import sim.field.continuous.*;
import sim.field.grid.IntGrid2D;
import sim.field.grid.SparseGrid2D;
import sim.util.*;

public class Wolf_small implements Steppable
    {
    public Int2D loc = new Int2D(0,0);
    public Int2D lastd = new Int2D(0,0);
    public SparseGrid2D fieldWolves;
    public SparseGrid2D fieldSheeps;
    public Wsg_small theWsg;
    public boolean dead = false;
    public int energy = 0;
    public Wolf_small(Int2D location) { loc = location; }
    
    public boolean isDead() { return dead; }
    public void setDead(boolean val) { dead = val; }
        
    public void step(SimState state)
        {     
        if (dead) return;

        final Wsg_small wsg = (Wsg_small)state;
        
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
        wsg.fieldWolves.setObjectLocation(this, loc);
        
        Bag a = wsg.fieldSheeps.getObjectsAtLocation(loc.x, loc.y);
        Bag b = new Bag();

        if (a != null && a.numObjs > 0){
            for (int k = 0; k < a.numObjs; k++) {
                Sheep_small s = (Sheep_small) a.objs[k];
                if (!s.isDead())
                {
                    b.add(s);
                }
            }
        }
        if (b != null && b.numObjs > 0){
            int q = wsg.random.nextInt(b.numObjs);
            Sheep_small s = (Sheep_small) b.objs[q];
            s.setDead(true);
            energy += 13;
        }
            
        energy -= 1;
        if (energy <= 0) {
            dead = true;
            state.schedule.scheduleOnce(this);
            return;
        }

        //reproduce
        if (wsg.random.nextDouble() < 0.1) {
            energy /= 2;
            Int2D location = new Int2D(loc.x, loc.y);

            Wolf_small w = new Wolf_small(location);
            w.energy = energy;

            wsg.fieldWolves.setObjectLocation(w, location);
            Schedule schedule = state.schedule;
            schedule.scheduleRepeating(w, 2, 1.0);
        }

        }
    }