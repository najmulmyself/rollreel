# RollReel UI design guide

Use this guide for design concepts, UI changes, and design reviews in RollReel. The eight principles come from the Kree8.studio cheatsheet shared by the project owner. The examples below apply them to RollReel.

## 1. Show the value early

Let people see what they can do before asking for access or decisions. Keep onboarding short, use friendly language, and give each step one primary action. Explain what Photos access enables where the person can act on it.

## 2. Give motion a job

Use motion to acknowledge a press, connect a screen to the control that opened it, or show a change in state. Let it settle promptly and respect Reduce Motion. For example, keep the Watch next thumbnail in place as the video loads into the player.

## 3. Make empty states useful

Design a distinct state for an empty library, missing access, and a failed load. Explain what happened and offer one action the person can take. Use the kingfisher or app illustrations when they make the state easier to understand.

## 4. Match haptics to the action

Use light selection feedback for deliberate taps and stronger feedback for completed actions when it helps confirm success. Choose feedback that reflects what actually happened, especially for actions that can fail.

## 5. Treat icons like typography

Use a consistent icon family, stroke weight, and alignment within a flow. Pair a filled or heavier selected icon with color so the state is recognizable in both light and dark appearances. Give icon-only actions accessible labels.

## 6. Make feedback immediate

Acknowledge a tap before waiting for work to finish. For loading, use a skeleton that keeps the layout stable. Use optimistic updates for reversible actions and restore the previous state if the operation fails. On Home, a favorite can update immediately, while a video launch needs a pressed state and a clear path into playback.

## 7. Write like a person

Use short, specific copy that describes the situation and the next action. For example, “Photos access is off. Open Settings to choose which videos RollReel can see.” Use real library data for titles, thumbnails, and counts. Show a concise status for an unavailable feature where it is useful to the person.

## 8. Study the interaction behind a reference

Look at how a good app sets hierarchy, spaces touch targets, communicates selected states, and handles transitions. Apply the principle to RollReel’s own content and controls. Check the flow from launching the app to taking the primary action, including the empty and loading states.

## RollReel design defaults

- Use the existing SF Pro typography styles and the logo’s navy, cobalt, and cyan palette. Use the approved kingfisher where its presence supports the task.
- Review type at small phone widths and with enlarged text. Check contrast, tap targets, and selected states alongside the visual layout.
- Use the latest approved concept for the screen. [RollReel_Design.md](RollReel_Design.md) provides background on the product and its components.
- When design approval is requested, show the relevant states and motion in the mockup before editing application code.
