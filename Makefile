MAIN_DIR := 讲义

.PHONY: all clean

all:
	$(MAKE) -C $(MAIN_DIR)

clean:
	# Cleaning...
	$(MAKE) -C $(MAIN_DIR) clean
