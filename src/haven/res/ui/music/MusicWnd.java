package haven.res.ui.music;

import haven.CheckBox;
import haven.Coord;
import haven.GOut;
import haven.IButton;
import haven.Resource;
import haven.Tex;
import haven.Text;
import haven.Theme;
import haven.UI;
import haven.Widget;
import haven.Window;

import java.awt.Color;
import java.awt.event.KeyEvent;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class MusicWnd extends Window {
    public static final Tex[] tips;
    public static final Map<Integer, Integer> keys;
    public static final int[] nti = {0, 2, 4, 5, 7, 9, 11}, shi = {1, 3, 6, 8, 10};
    public static final int[] ntp = {0, 1, 2, 3, 4, 5, 6}, shp = {0, 1, 3, 4, 5};
    public static final Tex[] ikeys;
    public final boolean[] cur = new boolean[12 * 3];
    public final int[] act;
    public final double start;
    public double latcomp = 0.15;
    public int actn;

    static {
        Map<Integer, Integer> km = new HashMap<>();
        km.put(KeyEvent.VK_Z, 0);
        km.put(KeyEvent.VK_S, 1);
        km.put(KeyEvent.VK_X, 2);
        km.put(KeyEvent.VK_D, 3);
        km.put(KeyEvent.VK_C, 4);
        km.put(KeyEvent.VK_V, 5);
        km.put(KeyEvent.VK_G, 6);
        km.put(KeyEvent.VK_B, 7);
        km.put(KeyEvent.VK_H, 8);
        km.put(KeyEvent.VK_N, 9);
        km.put(KeyEvent.VK_J, 10);
        km.put(KeyEvent.VK_M, 11);
        Tex[] il = new Tex[4];
        for (int i = 0; i < 4; i++) {
            il[i] = Resource.loadtex("ui/music", i);
        }
        String tc = "ZSXDCVGBHNJM";
        Text.Foundry fnd = new Text.Foundry(Text.fraktur.deriveFont(java.awt.Font.BOLD, 16)).aa(true);
        Tex[] tl = new Tex[tc.length()];
        for (int ki : nti) {
            tl[ki] = fnd.render(tc.substring(ki, ki + 1), new Color(0, 0, 0)).tex();
        }
        for (int ki : shi) {
            tl[ki] = fnd.render(tc.substring(ki, ki + 1), new Color(255, 255, 255)).tex();
        }
        keys = km;
        ikeys = il;
        tips = tl;
    }

    public static final Coord defSize = ikeys[0].sz().mul(nti.length, 1);
    public final CheckBox disable_keys = new CheckBox("Disable keys");
    public MusicBot musicBot;

    public final IButton plus = new IButton(Theme.fullres("buttons/circular/small/add"), () -> showBot(true));
    public final IButton minus = new IButton(Theme.fullres("buttons/circular/small/sub"), () -> showBot(false));

    public void showBot(boolean show) {
        if (show && musicBot == null) {
            musicBot = new MusicBot(this);
            add(musicBot, Coord.of(0, defSize.y));
        }
        plus.show(!show);
        minus.show(show);

        if (musicBot != null)
            musicBot.show(show);

        resize(show);
    }

    public void resize(boolean show) {
        resize((show) ? (Coord.of(Math.max(defSize.x, Objects.requireNonNull(musicBot).sz.x), defSize.y + musicBot.sz.y)) : (defSize));
    }

    public MusicWnd(String name, int maxpoly) {
        super(defSize, name, true);
        this.act = new int[maxpoly];
        this.start = System.currentTimeMillis() / 1000.0;

        adda(disable_keys, Coord.of(0, defSize.y), 0, 1);
        adda(plus, Coord.of(defSize.x / 2, defSize.y), 0.5, 1);
        adda(minus, Coord.of(defSize.x / 2, defSize.y), 0.5, 1);
        minus.hide();
    }

    public static Widget mkwidget(UI ui, Object[] args) {
        String nm = (String) args[0];
        int maxpoly = (Integer) args[1];
        return (new MusicWnd(nm, maxpoly));
    }

    protected void added() {
        super.added();
        ui.grabkeys(this);
    }

    @Override
    public void reqdestroy() {
        super.reqdestroy();
        if (musicBot != null)
            musicBot.reqdestroy();
    }

    public void cdraw(GOut g) {
        boolean[] cact = new boolean[cur.length];
        for (int i = 0; i < actn; i++)
            cact[act[i]] = true;
        int base = 12;
        if (ui.modshift) base += 12;
        if (ui.modctrl) base -= 12;
        for (int i = 0; i < nti.length; i++) {
            Coord c = new Coord(ikeys[0].sz().x * ntp[i], 0);
            boolean a = cact[nti[i] + base];
            g.image(ikeys[a ? 1 : 0], c);
            g.image(tips[nti[i]], c.add((ikeys[0].sz().x - tips[nti[i]].sz().x) / 2, ikeys[0].sz().y - tips[nti[i]].sz().y - (a ? 9 : 12)));
        }
        int sho = ikeys[0].sz().x - (ikeys[2].sz().x / 2);
        for (int i = 0; i < shi.length; i++) {
            Coord c = new Coord(ikeys[0].sz().x * shp[i] + sho, 0);
            boolean a = cact[shi[i] + base];
            g.image(ikeys[a ? 3 : 2], c);
            g.image(tips[shi[i]], c.add((ikeys[2].sz().x - tips[shi[i]].sz().x) / 2, ikeys[2].sz().y - tips[shi[i]].sz().y - (a ? 9 : 12)));
        }
    }

    public boolean keydown(KeyEvent ev) {
        if (!disable_keys.a) {
            double now = (ev.getWhen() / 1000.0) + latcomp;
            Integer keyp = keys.get(ev.getKeyCode());
            if (keyp != null) {
                int key = keyp + 12;
                if ((ev.getModifiersEx() & KeyEvent.SHIFT_DOWN_MASK) != 0) key += 12;
                if ((ev.getModifiersEx() & KeyEvent.CTRL_DOWN_MASK) != 0) key -= 12;
                if (!cur[key]) {
                    if (actn >= act.length) {
                        wdgmsg("stop", act[0], (float) (now - start));
                        for (int i = 1; i < actn; i++)
                            act[i - 1] = act[i];
                        actn--;
                    }
                    wdgmsg("play", key, (float) (now - start));
                    cur[key] = true;
                    act[actn++] = key;
                }
                return (true);
            }
        }
        return (super.keydown(ev));
    }

    private void stopnote(double now, int key) {
        if (cur[key]) {
            outer:
            for (int i = 0; i < actn; i++) {
                if (act[i] == key) {
                    wdgmsg("stop", key, (float) (now - start));
                    for (actn--; i < actn; i++)
                        act[i] = act[i + 1];
                    break outer;
                }
            }
            cur[key] = false;
        }
    }

    public boolean keyup(KeyEvent ev) {
        if (!disable_keys.a) {
            double now = (ev.getWhen() / 1000.0) + latcomp;
            Integer keyp = keys.get(ev.getKeyCode());
            if (keyp != null) {
                int key = keyp;
                stopnote(now, key);
                stopnote(now, key + 12);
                stopnote(now, key + 24);
                return (true);
            }
        }
        return (super.keyup(ev));
    }
}

