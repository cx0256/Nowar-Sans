module.exports = function(b, xScale) {
	for (let g in b.glyf) {
		if (!b.glyf[g] || !b.glyf[g].contours) continue;
		const glyph = b.glyf[g];
		glyph.advanceWidth = glyph.advanceWidth * xScale;
		for (let c of glyph.contours)
			for (let z of c) {
				z.x = z.x * xScale;
			}
	}
};
