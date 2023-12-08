include .env

DAY ?= $(shell date +"%d" | bc)

ifdef AOC_YEAR
YEAR := $(AOC_YEAR)
else
YEAR := 2024
endif

ifdef SWIFT_EXECUTABLE
SWIFT := $(SWIFT_EXECUTABLE)
else
SWIFT := swift
endif

ifdef RELEASE
EXECUTABLE_PATH := .build/release/Day$(DAY)
SWIFT_FLAGS := -c release
else
EXECUTABLE_PATH := .build/debug/Day$(DAY)
SWIFT_FLAGS := -c debug
endif

getinput: 
	@mkdir -p Sources/Day$(DAY)/Resources
	@curl -Ssl "https://adventofcode.com/$(YEAR)/day/$(DAY)/input" \
	  -A "getinput by Zollerboy1" \
	  -H "cookie: session=$(AOC_SESSION)" > Sources/Day$(DAY)/Resources/day$(DAY).txt

$(EXECUTABLE_PATH): Sources/Day$(DAY)/main.swift Sources/Day$(DAY)/Resources/day$(DAY).txt Package.swift
	$(SWIFT) build $(SWIFT_FLAGS) --product Day$(DAY)

build: $(EXECUTABLE_PATH)

run: build
	./$(EXECUTABLE_PATH)
	  
.PHONY: clean
clean:
	rm -rf .build
