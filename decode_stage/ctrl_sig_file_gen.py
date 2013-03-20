import csv

signals_file = 'control_signals.csv'
ignore_fields = ('OP', 'OPCODE')
template_file = 'control_unit.mako'
output_file = 'control_unit.v'

def main():
    csvfile = open(signals_file, 'r')
    ctrl_sig_reader = csv.DictReader(csvfile)
    fields = ctrl_sig_reader.fieldnames
    ctrl_signals = []
    signal_fields = []
    ctrl_signal_sizes = {}
    # Identify control signals needed
    for field in fields:
        signal_spec = field.split('[')
        sig = signal_spec[0]
        if not sig in ignore_fields:
            signal = sig.lower()
            ctrl_signals.append(signal)
            signal_fields.append(field)
            if len(signal_spec) == 2:
                sig_size = int(signal_spec[1].split(':')[0]) + 1
            else:
                sig_size = 1
            ctrl_signal_sizes[signal] = sig_size

    # Identify control signal values for each op
    ops = []
    for op_data in ctrl_sig_reader:
        op = {}
        for signal, field in zip(ctrl_signals, signal_fields):
            data = op_data[field]
            if data:
                val = data.replace("[", "").replace("]", "")
                val_size = len(val)
                sig_val = '%d\'b%s' % (val_size, val)
            else:
                sig_val = '%d\'d0' % ctrl_signal_sizes[signal]
            op[signal] = sig_val
        op['name'] = op_data['OP']
        op['opcode_hex'] = op_data['OPCODE']
        op['opcode'] = int(op['opcode_hex'], 16)
        ops.append(op)
   
    csvfile.close()

    # Write data to template file
    from mako.template import Template
    from mako.runtime import Context
    control_unit_template = Template(filename=template_file)
    control_unit_file = open(output_file, 'w')
    ctx = Context(control_unit_file, 
                  ctrl_signals=ctrl_signals,
                  ctrl_signal_sizes=ctrl_signal_sizes,
                  ops=ops)
    control_unit_template.render_context(ctx)
    control_unit_file.close()

if __name__ == "__main__":
    main()

