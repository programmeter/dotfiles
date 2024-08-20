enum {MaxMon = 8};
static int nmasters[MaxMon];
static int initnm = 0;

static void
initnmaster(void) {
	int i;

	if(initnm)
		return;
	for(i = 0; i < MaxMon; i++)
		nmasters[i] = nmaster;
	initnm = 1;
}

static void
incnmaster(const Arg *arg) {
	if(!arg || !selmon->lt[selmon->sellt]->arrange || selmon->num >= MaxMon)
		return;
	nmasters[selmon->num] += arg->i;
	if(nmasters[selmon->num] < 0)
		nmasters[selmon->num] = 0;
	arrange(NULL);
}

static void
setnmaster(const Arg *arg) {
	if(!arg || !selmon->lt[selmon->sellt]->arrange || selmon->num >= MaxMon)
		return;
	nmasters[selmon->num] = arg->i > 0 ? arg->i : 0;
	arrange(NULL);
}

static void
ntile(Monitor *m) {
	int x, y, h, w, mw, nm;
	unsigned int i, n;
	Client *c;

	initnmaster();
	for(n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	c = nexttiled(m->clients);
	nm = m->num < MaxMon ? nmasters[m->num] : nmaster;
	if(nm > n)
		nm = n;
	/* master */
	if(nm > 0) {
		mw = m->mfact * m->ww;
		h = m->wh / nm;
		if(h < bh)
			h = m->wh;
		y = m->wy;
		for(i = 0; i < nm; i++, c = nexttiled(c->next)) {
			resize(c, m->wx, y, (n == nm ? m->ww : mw) - 2 * c->bw,
			       ((i + 1 == nm) ? m->wy + m->wh - y : h) - 2 * c->bw, False);
			if(h != m->wh)
				y = c->y + HEIGHT(c);
		}
		n -= nm;
	} else
		mw = 0;
	if(n == 0)
		return;
	/* tile stack */
	x = m->wx + mw;
	y = m->wy;
	w = m->ww - mw;
	h = m->wh / n;
	if(h < bh)
		h = m->wh;
	for(i = 0; c; c = nexttiled(c->next), i++) {
		resize(c, x, y, w - 2 * c->bw,
		       ((i + 1 == n) ? m->wy + m->wh - y : h) - 2 * c->bw, False);
		if(h != m->wh)
			y = c->y + HEIGHT(c);
	}
}

static void
ncol(Monitor *m) {
	int x, y, h, w, mw, nm;
	unsigned int i, n;
	Client *c;

	initnmaster();
	for(n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	c = nexttiled(m->clients);
	nm = m->num < MaxMon ? nmasters[m->num] : nmaster;
	if(nm > n)
		nm = n;
	/* master */
	if(nm > 0) {
		mw = (n == nm) ? m->ww : m->mfact * m->ww;
		w = mw / nm;
        x = m->wx;
		for(i = 0; i < nm; i++, c = nexttiled(c->next)) {
			resize(c, x, m->wy, w - 2 * c->bw, m->wh - 2 * c->bw, False);
            x = c->x + WIDTH(c);
		}
		n -= nm;
	} else
		mw = 0;
	if(n == 0)
		return;
	/* tile stack */
	x = m->wx + mw;
	y = m->wy;
	w = m->ww - mw;
	h = m->wh / n;
	if(h < bh)
		h = m->wh;
	for(i = 0; c; c = nexttiled(c->next), i++) {
		resize(c, x, y, w - 2 * c->bw,
		       ((i + 1 == n) ? m->wy + m->wh - y : h) - 2 * c->bw, False);
		if(h != m->wh)
			y = c->y + HEIGHT(c);
	}
}

static void
nbstack(Monitor *m) {
	int x, y, h, w, mh, nm;
	unsigned int i, n;
	Client *c;

	initnmaster();
	for(n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	c = nexttiled(m->clients);
	nm = m->num < MaxMon ? nmasters[m->num] : nmaster;
	if(nm > n)
		nm = n;
	/* master */
	if(nm > 0) {
		mh = m->mfact * m->wh;
		w = m->ww / nm;
		if(w < bh)
			w = m->ww;
		x = m->wx;
		for(i = 0; i < nm; i++, c = nexttiled(c->next)) {
			resize(c, x, m->wy, ((i + 1 == nm) ? m->wx + m->ww - x : w) - 2 * c->bw,
			       (n == nm ? m->wh : mh) - 2 * c->bw, False);
			if(w != m->ww)
				x = c->x + WIDTH(c);
		}
		n -= nm;
	} else
		mh = 0;
	if(n == 0)
		return;
	/* tile stack */
	x = m->wx;
	y = m->wy + mh;
	w = m->ww / n;
	h = m->wh - mh;
	if(w < bh)
		w = m->ww;
	for(i = 0; c; c = nexttiled(c->next), i++) {
		resize(c, x, y, ((i + 1 == n) ? m->wx + m->ww - x : w) - 2 * c->bw,
		       h - 2 * c->bw, False);
		if(w != m->ww)
			x = c->x + WIDTH(c);
	}
}
