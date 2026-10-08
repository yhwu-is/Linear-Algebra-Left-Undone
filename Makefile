MAIN_DIR := 讲义

.PHONY: all clean figures figure

all:
	$(MAKE) -C $(MAIN_DIR)

figures:
	$(MAKE) -C $(MAIN_DIR) figures

figure:
	$(MAKE) -C $(MAIN_DIR) figure FIG=$(FIG)

clean:
	# Cleaning...
	$(MAKE) -C $(MAIN_DIR) clean
