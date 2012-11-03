#include <string>

#include "dialog.h"
#include "gmenu2x.h"
#define TR {printf("[Trace] in function %s, line %d, file %s\n",__FUNCTION__,__LINE__,__FILE__);}

Dialog::Dialog(GMenu2X *gmenu2x) : gmenu2x(gmenu2x) {}

void Dialog::drawTitleIcon(const std::string &icon, bool skinRes, Surface *s) {
	if (s==NULL)
		s = gmenu2x->s;

	Surface *i = NULL;
	if (!icon.empty()) {
		if (skinRes)
			i = gmenu2x->sc.skinRes(icon);
		else
			i = gmenu2x->sc[icon];
	}

	if (i==NULL) {
		TR;
		i = gmenu2x->sc.skinRes("icons/generic.png");
	}

	i->blit(s,4,(gmenu2x->skinConfInt["topBarHeight"]-32)/2, 32, 32);
}

void Dialog::writeTitle(const std::string &title, Surface *s) {
	if (s==NULL)
		s = gmenu2x->s;
	s->write(gmenu2x->font, title, 40, gmenu2x->skinConfInt["topBarHeight"]/2 -1, HAlignLeft, VAlignBottom);
}

void Dialog::writeSubTitle(const std::string &subtitle, Surface *s) {
	if (s==NULL)
		s = gmenu2x->s;
	s->write(gmenu2x->font, subtitle, 40, gmenu2x->skinConfInt["topBarHeight"]/2, HAlignLeft, VAlignTop);
}


