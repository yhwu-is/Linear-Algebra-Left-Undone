MAIN_DIR := 讲义
ANSWERS_DIR := 习题参考答案

export GH_ACTIONS_DIR := gh-actions-build

.PHONY: all gh-actions main ans clean

all: main ans

gh-actions:
# used by GitHub Actions
#	mkdir -p $(GH_ACTIONS_DIR)
#	make -C $(MAIN_DIR) gh-cp
#	make -C $(ANSWERS_DIR) gh-cp
	make -C $(MAIN_DIR)

main:
	$(MAKE) -C $(MAIN_DIR)

ans:
	$(MAKE) -C $(ANSWERS_DIR)

clean:
	# Cleaning...
	$(MAKE) -C $(MAIN_DIR) clean
	$(MAKE) -C $(ANSWERS_DIR) clean
	rm -rf $(GH_ACTIONS_DIR)
