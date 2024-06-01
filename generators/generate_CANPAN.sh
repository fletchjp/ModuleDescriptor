#!/bin/sh

# Generate descriptor file for CANMIO-SVO modules.
# Use this script to avoid duplication and reduce maintenance.

# Note: This does not use NV37 for testing servos. Instead using the outputOnWrite flag for end positions
# which writes the corresponding end position NV, just like is done for CANMIO. Works fine.

# Used to omit trailing comma at end of lists.
ending[0]=',' # False - not end of list, add a comma.
ending[1]=''  # True  - at end of list, omit trailing comma.

cat <<EOF
{
  "generated":"Generated by $0",
  "moduleName":"CANPAN",
  "nodeVariables": [
      {
      "type": "NodeVariableSelect",
      "nodeVariableIndex": 1,
      "displayTitle": "Startup Actions",
      "options": [
        {"label": "0 - Send all current taught event states", "value": 0},
        {"label": "1 - Do nothing", "value": 1},
        {"label": "2 - Set all taught states to ON", "value": 2}
      ]
    }
  ],
  "eventVariables": [
    {
      "displayTitle": "Event Direction",
      "type": "EventVariableSelect",
      "eventVariableIndex": 1,
      "options": [
        {
          "value": 0,
          "label": "Consumed Event"
        },
        {
          "value": 1,
          "label": "Produced Event"
        }
      ]
    },
    {
      "displayTitle": "Consumed Event",
      "type": "EventVariableGroup",
      "visibilityLogic": {
        "ev": 1,
        "equals": 0
      },
      "groupItems": [
        {
          "displayTitle": "LED Action",
          "type": "EventVariableSelect",
          "eventVariableIndex": 13,
          "options": [
            { "value":   0, "label": "Undefined (0)" },
            { "value": 255, "label": "Normal" },
            { "value": 254, "label": "ON Only" },
            { "value": 253, "label": "OFF Only" },
            { "value": 248, "label": "Flash" }
          ]
        },
EOF
for ch in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32
do
  cat <<EOF
        {
          "displayTitle": "LED $ch",
          "type": "EventVariableGroup",
          "groupItems": [
            {
              "displayTitle": "Turn ON",
              "type": "EventVariableBitSingle",
              "eventVariableIndex": $((5+($ch-1)/8)),
              "bit": $((($ch-1)%8))
            },
            {
              "displayTitle": "Invert",
              "type": "EventVariableBitSingle",
              "eventVariableIndex": $((9+($ch-1)/8)),
              "bit": $((($ch-1)%8))
            }
          ]
        }${ending[$(($ch == 32))]}
EOF
done
cat <<EOF
      ]
    },
    {
      "displayTitle": "Produced Event",
      "type": "EventVariableGroup",
      "visibilityLogic": {
        "ev": 1,
        "equals": 1
      },
      "groupItems": [
        {
          "displayTitle": "Switch",
          "type": "EventVariableNumber",
          "eventVariableIndex": 2,
          "min": 1,
          "max": 32
        },
        {
          "displayTitle": "Mode",
          "type": "EventVariableSelect",
          "eventVariableIndex": 3,
          "bitMask": 15,
          "options": [
            { "value": 0, "label": "None" },
            { "value": 1, "label": "ON/OFF" },
            { "value": 3, "label": "OFF/ON (inverted)" },
            { "value": 4, "label": "ON only" },
            { "value": 6, "label": "OFF only" },
            { "value": 8, "label": "ON/OFF push button" }
          ]
        },
        {
          "displayTitle": "Set LEDs",
          "type": "EventVariableBitSingle",
          "eventVariableIndex": 3,
          "bit": 4
        },
        {
          "displayTitle": "Send Short Event",
          "type": "EventVariableBitSingle",
          "eventVariableIndex": 3,
          "bit": 5
        }
      ]
    }
  ]
}
EOF