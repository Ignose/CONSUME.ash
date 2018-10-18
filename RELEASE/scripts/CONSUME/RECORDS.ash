//=============================================================================
// ORGANSPACE
//=============================================================================
record OrganSpace
{
	int fullness;
	int inebriety;
	int spleen;
};

//=============================================================================
// RANGE
//=============================================================================
record Range
{
	int min;
	int max;
};

void multiply_round_down(Range r, float x)
{
	r.min = floor(r.min.to_float() * x);
	r.max = floor(r.max.to_float() * x);
}

void multiply_round_up(Range r, float x)
{
	r.min = ceil(r.min.to_float() * x);
	r.max = ceil(r.max.to_float() * x);
}

void multiply_round_nearest(Range r, float x)
{
	r.min = round(r.min.to_float() * x);
	r.max = round(r.max.to_float() * x);
}

void add(Range r, int x)
{
	r.min += x;
	r.max += x;
}

void add(Range r, Range r2)
{
	r.min += r2.min;
	r.max += r2.max;
}

float average(Range r)
{
	return (r.min.to_float() + r.max.to_float()) / 2.0;
}

//=============================================================================
// ORGANCLEANING
//=============================================================================
record OrganCleaning
{
	int organ;
	int space;
};

//=============================================================================
// CONSUMABLE
//=============================================================================
record Consumable
{
	item it;
	int space;
	int organ;
	boolean useForkMug;
	OrganCleaning [int] cleanings;
};

boolean is_nothing(Consumable c)
{
	return c.it == $item[none];
}

boolean is_same(Consumable c1, Consumable c2)
{
	return c1.it == c2.it;
}

//=============================================================================
// DIET
//=============================================================================
record Diet
{
	Consumable [int] consumables;
	int [item] counts;
};

boolean within_limit(Diet d, Consumable c)
{
	return (daily_limit(c.it) == -1) || (d.counts[c.it] < daily_limit(c.it));
}

boolean add_consumable(Diet d, Consumable c)
{
	if(!d.within_limit(c))
		return false;
	d.consumables[d.consumables.count()] = c;
	d.counts[c.it]++;
	return true;
}

OrganSpace total_space(Diet d)
{
	OrganSpace os = new OrganSpace(0, 0, 0);
	foreach i,c in d.consumables
	{
		switch(c.organ)
		{
			case ORGAN_STOMACHE: os.fullness += c.space; break;
			case ORGAN_LIVER: os.inebriety += c.space; break;
			case ORGAN_SPLEEN: os.spleen += c.space; break;
		}
	}
	return os;
}
