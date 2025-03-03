class zmod:
    def __init__(self, config):
        self.printer = config.get_printer()
        gcode = self.printer.lookup_object('gcode')
        gcode.register_command(
            'SAVE_SHAPER', self.cmd_SAVE_SHAPER,
            desc=self.cmd_SAVE_SHAPER_help
        )

    cmd_SAVE_SHAPER_help = "Сохранить параметры шейпера в конфигурацию"
    def cmd_SAVE_SHAPER(self, gcmd):
        shaper_name = gcmd.get('NAME', '').lower()
        frequency = gcmd.get_float('FREQUENCY', 0.0)
        shaper_axis = gcmd.get('AXIS', '').lower()

        # Валидация параметров
        valid_shapers = ['mzv', 'zv', 'zvd', 'ei', '2hump_ei', '3hump_ei']
        if shaper_name not in valid_shapers:
            raise gcmd.error("Неверный шейпер. Допустимые: %s" % ', '.join(valid_shapers))
        if frequency <= 0:
            raise gcmd.error("Частота должна быть > 0")
        if shaper_axis not in ['x', 'y']:
            raise gcmd.error("Ось должна быть X или Y")

        # Сохранение параметров через Klipper API
        configfile = self.printer.lookup_object('configfile')
        configfile.set('input_shaper', 'shaper_type_%s' % shaper_axis, shaper_name)
        configfile.set('input_shaper', 'shaper_freq_%s' % shaper_axis, "%.1f" % frequency)

        # Информационное сообщение
        gcmd.respond_info(
            "Параметры для оси %s сохранены. Для применения выполните SAVE_CONFIG" % 
            shaper_axis.upper()
        )

def load_config(config):
    return zmod(config)
