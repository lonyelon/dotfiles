import argparse
import beanquery
import re
import subprocess

from mergedeep import merge


def dict_recurr_sum(D):
    ''' Recurr into a dictionary D and sum all the values of the leaf nodes '''

    sum_result = 0.0
    for k, v in D.items():
        if type(v) is dict:
            sum_result += dict_recurr_sum(v)
        else:
            sum_result += float(str(v.get_currency_units("EUR")).split(' ')[0])
    return sum_result


def dict_recurr_print(D, print_result=True, prefix='', tree_view=False):
    ''' Recursively print a dictionary D including the values for each node '''

    lines = []
    for k, v in sorted(D.items()):
        lines.append([f'{prefix}{k} '])
        if type(v) is dict:
            if len(v.keys()) > 1 or not tree_view:
                val = str(round(dict_recurr_sum(v), 2))
                if len(val.split('.')[1]) == 1:
                    val = f'{val}0'
                lines[-1].append(f'{val} EUR')
                lines += dict_recurr_print(
                    v,
                    prefix=f'{prefix}  ' if tree_view else f'{prefix}{k}:',
                    print_result=False,
                    tree_view=tree_view
                )
            else:
                # TODO: simplify this, there is only one key, there should not
                #       be a reason for a for-loop.
                for kk, vv in v.items():
                    val = re.sub(
                        r'^(-?[0-9]+\.[0-9]{2})[0-9]* EUR$',
                        '\\1 EUR',
                        str(vv.get_currency_units("EUR"))
                    )
                    lines[-1] = [f"{prefix}{k}:{kk} ", f"{val}"]
        else:
            val = re.sub(
                r'^(-?[0-9]+\.[0-9]{2})[0-9]* EUR$',
                '\\1 EUR',
                str(v.get_currency_units("EUR"))
            )
            lines[-1].append(f'{val}')

    if print_result:
        max_len_0 = 0
        max_len_1 = 0
        for line in lines:
            curr_len_0 = len(line[0])
            if curr_len_0 > max_len_0:
                max_len_0 = curr_len_0
            curr_len_1 = len(line[1])
            if curr_len_1 > max_len_1:
                max_len_1 = curr_len_1
        for line in lines:
            curr_len_0 = len(line[0])
            curr_len_1 = len(line[1])
            spaces = ' ' * (max_len_0 + max_len_1 - curr_len_0 - curr_len_1)
            print(spaces.join(line))

    return lines


def run_and_print_query(file, query, tree=False, tree_view=False):
    ''' Run bean-query with given file and query '''

    conn = beanquery.connect(f"beancount:{file}")
    curs = conn.execute(query)

    data = dict()
    if tree:
        for k, v in dict(curs.fetchall()).items():
            parts = k.split(':')
            curr_data = dict()
            data_pointer = curr_data
            for i, vv in enumerate(parts):
                data_pointer[vv] = v if i == len(parts) - 1 else dict()
                data_pointer = data_pointer[vv]
            merge(data, curr_data)
    else:
        data = dict(curs.fetchall())

    dict_recurr_print(data, tree_view=tree_view)


def handle_expenses(args):
    date_array = args.date.split('-') if args.date else []
    year_and = f'AND year={date_array[0]}' if len(date_array) > 0 else ''
    month_and = f'AND month={date_array[1]}' if len(date_array) > 1 else ''
    query = (
        'SELECT account, sum(position)'
        "WHERE account ~ 'Gastos:*'"
        f'{year_and} {month_and}'
        'GROUP BY account'
    ) if not args.only_taxes else (
        'SELECT account, sum(position)'
        f'WHERE (account ~ "Gastos:Impuestos" OR account="Gastos:Piso:IBI")'
        f'{year_and} {month_and}'
        'GROUP BY account'
    )
    run_and_print_query(args.file, query, tree=args.tree, tree_view=args.human)


def handle_balance(args):
    query = (
        "BALANCES WHERE"
        "   account = 'Activos:Santander:Nomina'"
        "OR account = 'Activos:Santander:CuentaCompartida'"
        "OR account ~ 'Activos:Emma'"
        "OR account = 'Pasivos:Santander:Credito'"
        "OR account = 'Pasivos:Emma'"
    )
    run_and_print_query(args.file, query, tree=args.tree)


def handle_check(args):
    subprocess.run(["bean-check", args.file])


def main():
    parser = argparse.ArgumentParser(
        prog="bean",
        description="Wrapper for bean-query."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    p_exp = subparsers.add_parser("expenses", aliases=["e"])
    p_exp.add_argument("file")
    p_exp.add_argument("-t", "--tree", action='store_true')
    p_exp.add_argument("-H", "--human", action='store_true')
    p_exp.add_argument("-T", "--only-taxes", action='store_true')
    p_exp.add_argument("-d", "--date", type=str)
    p_exp.set_defaults(func=handle_expenses)

    p_bal = subparsers.add_parser("balance", aliases=["b", "bal", "balances"])
    p_bal.add_argument("file")
    p_bal.add_argument("-t", "--tree", action='store_true')
    p_bal.add_argument("-y", "--year", type=int)
    p_bal.add_argument("-d", "--date", type=str)
    p_bal.set_defaults(func=handle_balance)

    p_bal = subparsers.add_parser("check", aliases=["c"])
    p_bal.add_argument("file")
    p_bal.set_defaults(func=handle_check)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
