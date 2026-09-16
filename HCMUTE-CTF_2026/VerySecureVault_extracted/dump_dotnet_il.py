import sys

sys.path.insert(0, r".\_pydeps")

import dnfile
from dncil.cil.body.reader import read_method_body_from_bytes
from dncil.clr.token import Token


TABLES = {
    0x01: "TypeRef",
    0x02: "TypeDef",
    0x04: "Field",
    0x06: "MethodDef",
    0x0A: "MemberRef",
    0x1B: "TypeSpec",
    0x2B: "MethodSpec",
}


def sval(value):
    return str(value) if value is not None else ""


def parent_name(index):
    if index is None or getattr(index, "row", None) is None:
        return "?"
    row = index.row
    ns = sval(getattr(row, "TypeNamespace", ""))
    name = sval(getattr(row, "TypeName", getattr(row, "Name", "?")))
    return f"{ns}.{name}".strip(".")


def main(path, filters):
    pe = dnfile.dnPE(path)
    md = pe.net.mdtables
    owners = {}
    for typ in md.TypeDef.rows:
        full = f"{sval(typ.TypeNamespace)}.{sval(typ.TypeName)}".strip(".")
        for idx in typ.MethodList:
            owners[id(idx.row)] = full

    def token_text(token):
        if not isinstance(token, Token):
            return str(token)
        if token.table == 0x70:
            item = pe.net.user_strings.get(token.rid)
            return repr(str(item)) if item is not None else str(token)
        table_name = TABLES.get(token.table)
        table = getattr(md, table_name, None) if table_name else None
        if table is None or token.rid < 1 or token.rid > len(table.rows):
            return str(token)
        row = table.rows[token.rid - 1]
        name = sval(getattr(row, "Name", getattr(row, "TypeName", "?")))
        if table_name == "MethodDef":
            return f"{owners.get(id(row), '?')}::{name}"
        if table_name == "MemberRef":
            return f"{parent_name(getattr(row, 'Class', None))}::{name}"
        if table_name in ("TypeRef", "TypeDef"):
            ns = sval(getattr(row, "TypeNamespace", ""))
            return f"{ns}.{name}".strip(".")
        return f"{table_name}::{name}"

    for rid, method in enumerate(md.MethodDef.rows, 1):
        owner = owners.get(id(method), "?")
        fullname = f"{owner}::{sval(method.Name)}"
        if filters and not any(x.lower() in fullname.lower() for x in filters):
            continue
        print(f"\n===== {fullname} [MethodDef {rid}, RVA 0x{method.Rva:X}] =====")
        if not method.Rva:
            continue
        try:
            off = pe.get_offset_from_rva(method.Rva)
            body = read_method_body_from_bytes(pe.__data__[off:])
            for ins in body.instructions:
                operand = token_text(ins.operand) if ins.operand is not None else ""
                print(f"IL_{ins.offset - body.offset:04X}: {ins.mnemonic:<12} {operand}")
        except Exception as exc:
            print(f"<parse error: {exc}>")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2:])
