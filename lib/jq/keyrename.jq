def keyrename($o): with_entries(.key |= ($o[.] // .) );
def keyrename($from;$to): keyrename({($from):$to});
