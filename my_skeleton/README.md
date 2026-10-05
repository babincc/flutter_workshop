# Skeleton Code

**[View source code](lib)**

This is skeleton (starter) code for a new Flutter project.

<br>

## Folder Structure

[Here](lib/folder_structure.txt) is the folder structure I like to use for Flutter projects.

### Run with the IDE play button

1. Replace the placeholders in `dev/config/supabase.json` with your project URL
   and publishable key.
2. In Android Studio/IntelliJ, select **Supabase** in the run-configuration
   dropdown and click Run. The shared configuration is `.run/Supabase.run.xml`.
   Alternatively, edit your existing **main.dart** configuration under
   **Run > Edit Configurations** and enter
   `--dart-define-from-file=dev/config/supabase.json` in **Additional run args**.
3. In VS Code, select **Supabase** in Run and Debug and click Run. Its launch
   configuration reads the same file.

Restart the app after changing build configuration. For command-line runs or
builds, pass `--dart-define-from-file=dev/config/supabase.json` as well. The JSON
file is deliberately trackable because these are public client values; it must
not contain backend secrets.
