// Portable pre-edit hook for agent clients that support command hooks.
// Reads a JSON event on stdin and exits non-zero when an edit targets a .py file.
let data = '';
process.stdin.on('data', (chunk) => (data += chunk));
process.stdin.on('end', () => {
  let input = {};
  try {
    input = JSON.parse(data);
  } catch {
    process.exit(0);
  }

  const directTarget =
    input.tool_input?.file_path ??
    input.toolInput?.filePath ??
    input.file_path ??
    input.filePath ??
    input.path ??
    '';
  const command = input.tool_input?.command ?? input.toolInput?.command ?? input.command ?? '';
  const patchTargets = Array.from(
    command.matchAll(/^(?:\*\*\* (?:Add|Update|Delete) File:|\+\+\+ b\/|--- a\/)\s*(.+)$/gim),
    (match) => match[1].trim(),
  );
  const blockedTarget = [directTarget, ...patchTargets].find((target) => /\.py$/i.test(target));

  if (blockedTarget) {
    const reason = `Blocked by the Steading learning contract: ${blockedTarget} must be written by the user. See AGENTS.md and docs/training/python.md.`;
    console.log(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'PreToolUse',
          permissionDecision: 'deny',
          permissionDecisionReason: reason,
        },
      }),
    );
    process.exit(0);
  }

  process.exit(0);
});
