import sim.field.grid.ObjectGrid2D;
import sim.engine.SimState;
import sim.util.IntBag;
import sim.util.Int2D;
import sim.engine.Steppable;

public class Agent_small implements Steppable
{
    Int2D loc;
    public ObjectGrid2D neighbors;
    public int group
    public bool mood
    IntBag neighborsX;
    IntBag neighborsY;

    public Agent_small(final int x, final int y, final int group, final bool mood) {
        this.loc = new Int2D(x, y);
        this.group = group;
        this.mood = mood;
        this.neighborsX = new IntBag(9);
        this.neighborsY = new IntBag(9);
    }

    public void step(final SimState state) {
        final Schelling_small sch = (Schelling_small)state;
        final int[][] locs = sch.neighbors.field;
        final int x = this.loc.x;
        final int y = this.loc.y;
        final int neighborhood = sch.neighborhood;
        final IntGrid2D neighbors2 = sch.neighbors;
        neighbors.getMooreLocations(x, y, neighborhood, 0, true, this.neighborsX, this.neighborsY);
        double val = 0.0;
        final int threshold = sch.threshold;
        final int numObjs = this.neighborsX.numObjs;
        final int[] objsX = this.neighborsX.objs;
        final int[] objsY = this.neighborsY.objs;
        final int myVal = locs[x][y];
        for (int i = 0; i < numObjs; ++i) {
            if (locs[objsX[i]][objsY[i]] == myVal && (objsX[i] != x || objsY[i] != y)) {
                val += 1.0;
            }
        if (val >= threshold) {
            this.mood = true      
            }
        else {
            final int newLocIndex = state.random.nextInt(sch.emptySpaces.numObjs);
            final Int2D newLoc = (Int2D)sch.emptySpaces.objs[newLocIndex];
            sch.emptySpaces.objs[newLocIndex] = this.loc;
            final int swap = locs[newLoc.x][newLoc.y];
            locs[newLoc.x][newLoc.y] = locs[this.loc.x][this.loc.y];
            locs[this.loc.x][this.loc.y] = swap;
            this.loc = newLoc;
        }
    }
}
