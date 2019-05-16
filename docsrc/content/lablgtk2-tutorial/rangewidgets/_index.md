---
title: "Range widgets"
pre: "9. "
weight: 90
description: "The category of range widgets includes the ubiquitous scrollbar widget and the less common scale widget."
---

The category of range widgets includes the ubiquitous scrollbar widget and the less common scale widget.
Though these two types of widgets are generally used for different purposes, they are quite similar in function and implementation. All range widgets share a set of common graphic elements, each of which has its own X window and receives events. They all contain a "trough" and a "slider" (what is sometimes called a "thumbwheel" in other GUI environments). Dragging the slider with the pointer moves it back and forth within the trough, while clicking in the trough advances the slider towards the location of the click, either completely, or by a designated amount, depending on which mouse button is used.

As mentioned in Adjustments above, all range widgets are associated with an adjustment object, from which they calculate the length of the slider and its position within the trough. When the user manipulates the slider, the range widget will change the value of the adjustment.


