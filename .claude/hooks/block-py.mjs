// PreToolUse hook: deterministically blocks agent writes to .py files.
// The training protocol (docs/training/README.md) requires all Python to be hand-written by the user.
let data = '';
process.stdin.on('data', (c) => (data += c));
process.stdin.on('end', () => {
  let input = {};
  try {
    input = JSON.parse(data);
  } catch {
    process.exit(0);
  }
  const file = input.tool_input?.file_path ?? '';
  if (/\.py$/i.test(file)) {
    console.log(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'PreToolUse',
          permissionDecision: 'deny',
          permissionDecisionReason: `BLOCKED by training protocol: ${file} — all Python is hand-written by the user. Coach instead of writing (see docs/training/python.md).`,
        },
      }),
    );
  }
  process.exit(0);
});
