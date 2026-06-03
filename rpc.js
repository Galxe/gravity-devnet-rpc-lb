// Parse JSON-RPC body to detect privileged method calls.
// Returns "1" if any call in the request is a debug_* or trace_* method,
// "0" otherwise. Batch requests: any single privileged method → whole batch is "1".
// fail-open: parse errors return "0" so reth handles invalid JSON itself (415/400).
function isPrivileged(r) {
    try {
        var body = r.requestText;
        if (!body) return "0";
        var parsed = JSON.parse(body);
        var calls = Array.isArray(parsed) ? parsed : [parsed];
        for (var i = 0; i < calls.length; i++) {
            var m = calls[i] && calls[i].method;
            if (typeof m === "string" &&
                (m.indexOf("debug_") === 0 || m.indexOf("trace_") === 0)) {
                return "1";
            }
        }
        return "0";
    } catch (e) {
        return "0";
    }
}

export default { isPrivileged };
