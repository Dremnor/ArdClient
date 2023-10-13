package haven.res.ui.stackinv;

import haven.Coord;
import haven.DTarget;
import haven.GItem;
import haven.GameUI;
import haven.Inventory;
import haven.UI;
import haven.WItem;
import haven.Widget;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ItemStack extends Widget implements DTarget, Inventory.InventoryListener {
    public final List<GItem> order = new ArrayList<>();
    public final Map<GItem, WItem> wmap = new HashMap<>();
    private boolean dirty;

    public static ItemStack mkwidget(UI ui, Object[] args) {
        return (new ItemStack());
    }

    @Override
    public void tick(double dt) {
        super.tick(dt);
        if (dirty) {
            int x = 0, y = 0;
            for (GItem item : order) {
                WItem w = wmap.get(item);
                w.move(new Coord(x, 0));
                x += w.sz.x;
                y = Math.max(y, w.sz.y);
            }
            resize(x, y);
            dirty = false;
        }
    }

    @Override
    public void addchild(Widget child, Object... args) {
        add(child);
        if (child instanceof GItem) {
            GItem i = (GItem) child;
            wmap.put(i, add(new WItem(i)));
            order.add(i);
            dirty = true;
            i.addListeners(listeners());
        }
    }

    @Override
    public void cdestroy(Widget w) {
        super.cdestroy(w);
        if (w instanceof GItem) {
            GItem i = (GItem) w;
            wmap.remove(i).reqdestroy();
            order.remove(i);
            dirty = true;
            i.removeListeners(listeners());
        }
    }

    @Override
    public void cresize(Widget ch) {
        dirty = true;
    }

    @Override
    public boolean mousewheel(Coord c, int amount) {
        if (ui.modshift) {
            Inventory minv = getparent(GameUI.class).maininv;
            if (amount < 0)
                wdgmsg("invxf", minv.wdgid(), 1);
            else if (amount > 0)
                minv.wdgmsg("invxf", this.wdgid(), 1);
        }
        return (true);
    }

    @Override
    public boolean drop(Coord cc, Coord ul) {
        wdgmsg("drop");
        return (true);
    }

    @Override
    public boolean iteminteract(Coord cc, Coord ul) {
        return (false);
    }

    @Override
    public void dirty() {}

    private final List<Inventory.InventoryListener> listeners = Collections.synchronizedList(new ArrayList<>());

    @Override
    public void initListeners(final List<Inventory.InventoryListener> listeners) {}

    @Override
    public List<Inventory.InventoryListener> listeners() {
        return (listeners);
    }
}