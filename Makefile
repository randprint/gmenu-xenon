# Export a OPEN2X environment variable pointing to the open2x toolchain
ifeq ($(strip $(DEVKITXENON)),)
$(error "Please set DEVKITXENON in your environment. export DEVKITXENON=<path to>devkitPPC")
endif

include $(DEVKITXENON)/rules
    
CC= $(PREFIX)gcc
CXX = $(PREFIX)g++
STRIP = $(PREFIX)strip

#CFLAGS = -I"$(DEVKITXENON)/usr/include" -I"$(DEVKITXENON)/usr/include/SDL" -DLOG_LEVEL=4 -DTARGET=$(TARGET) -DTARGET_PC -g $(MACHDEP) -ffunction-sections -fdata-sections -fomit-frame-pointer -ffast-math -funroll-loops -fno-exceptions -Wall -Wno-unknown-pragmas -Wno-format 
CFLAGS = -I"$(DEVKITXENON)/usr/include" -I"$(DEVKITXENON)/usr/include/SDL" -DLOG_LEVEL=4 -DTARGET=$(TARGET) -DTARGET_PC -g $(MACHDEP) -ffunction-sections -fdata-sections -Wall
CXXFLAGS = $(CFLAGS)
LDFLAGS = $(MACHDEP) /usr/local/xenon/usr/lib/libxenon.a -L/usr/local/xenon/usr/lib -L$(CHAINPREFIX)/lib -lSDL_image -lSDL_ttf -lfreetype -lSDL_gfx -lfat -lpng -lSDL -lbz2 -lz -lxenon -lc -n -T /usr/local/xenon/app.lds

OBJDIR = objs/$(TARGET)
DISTDIR = dist/$(TARGET)/gmenu2x
APPNAME = $(OBJDIR)/gmenu2x

SOURCES := $(wildcard src/*.cpp)
OBJS := $(patsubst src/%.cpp, $(OBJDIR)/src/%.o, $(SOURCES))

# File types rules
$(OBJDIR)/src/%.o: src/%.cpp src/%.h
	$(CXX) $(CFLAGS) -o $@ -c $<

all: dir static

dir:
	@if [ ! -d $(OBJDIR)/src ]; then mkdir -p $(OBJDIR)/src; fi

debug-static: $(OBJS)
	@echo "Linking gmenu2x-debug..."
	$(CXX) -o $(APPNAME)-debug $(OBJS) -static $(LDFLAGS)

debug-shared: $(OBJS)
	@echo "Linking gmenu2x-debug..."
	$(CXX) -o $(APPNAME)-debug  $(LDFLAGS) $(OBJS)

shared: debug-shared
	$(STRIP) $(APPNAME)-debug -o $(APPNAME)

static: debug-static
	$(STRIP) $(APPNAME)-debug -o $(APPNAME)

clean:
	rm -rf $(OBJDIR) $(DISTDIR) *.gcda *.gcno $(APPNAME)

dist: dir static
	install -m755 -D $(APPNAME) $(DISTDIR)/gmenu2x
	install -m755 -d $(DISTDIR)/sections/applications $(DISTDIR)/sections/emulators $(DISTDIR)/sections/games $(DISTDIR)/sections/settings
	install -m644 -D README.rst $(DISTDIR)/README.txt
	install -m644 -D COPYING $(DISTDIR)/COPYING
	install -m644 -D ChangeLog $(DISTDIR)/ChangeLog
	cp -RH assets/skins assets/translations assets/$(TARGET)/* $(DISTDIR)
	mv $(DISTDIR)/autorun.gpu $(DISTDIR)/..

-include $(patsubst src/%.cpp, $(OBJDIR)/src/%.d, $(SOURCES))

$(OBJDIR)/src/%.d: src/%.cpp
	@if [ ! -d $(OBJDIR)/src ]; then mkdir -p $(OBJDIR)/src; fi
	$(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$
