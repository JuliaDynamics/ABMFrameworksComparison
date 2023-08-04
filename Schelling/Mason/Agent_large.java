import sim.field.grid.ObjectGrid2D;
import sim.engine.SimState;
import sim.util.IntBag;
import sim.util.Int2D;
import sim.engine.Steppable;

public class Agent_large implements Steppable
{
    Int2D loc;
    public ObjectGrid2D neighbors;
    public int group;
    public boolean mood;
    IntBag neighborsX;
    IntBag neighborsY;

    public Agent_large(final int x, final int y, final int group, final boolean mood) {
        this.loc = new Int2D(x, y);
        this.group = group;
        this.mood = mood;
        this.neighborsX = new IntBag(25);
        this.neighborsY = new IntBag(25);
    }

    public void step(final SimState state) {
        final Schelling_large sch = (Schelling_large)state;
        final int x = this.loc.x;
        final int y = this.loc.y;
        final int neighborhood = sch.neighborhood;
        final ObjectGrid2D neighbors2 = sch.neighbors;
        neighbors2.getMooreLocations(x, y, neighborhood, 0, true, this.neighborsX, this.neighborsY);
        double val = 0.0;
        final int threshold = sch.threshold;
        final int numObjs = this.neighborsX.numObjs;
        final int[] objsX = this.neighborsX.objs;
        final int[] objsY = this.neighborsY.objs;
        for (int i = 0; i < numObjs; ++i) {
            Object o = neighbors2.field[objsX[i]][objsY[i]];
            if (o != null) {
                Agent_large neigh = (Agent_large)o;
                if (neigh.group == this.group && (objsX[i] != x || objsY[i] != y)) {
                    val += 1.0;
                }
            }
        }
        if (val >= threshold) {
            this.mood = true;     
            }
        else {
            final int newLocIndex = state.random.nextInt(sch.emptySpaces.numObjs);
            final Int2D newLoc = (Int2D)sch.emptySpaces.objs[newLocIndex];
            sch.emptySpaces.objs[newLocIndex] = this.loc;
            this.loc = newLoc;
        }
    }
}
