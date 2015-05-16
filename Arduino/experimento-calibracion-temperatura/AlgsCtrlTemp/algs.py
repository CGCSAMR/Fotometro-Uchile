#!/usr/bin/env python      
# -*- coding: utf-8 -*-


import time
# from ClientSideServices import botonera
from ClientSideServices import modulotermico
# from ClientSideServices import general
from ClientSideServices import modulotermico


def ramp_pwm_adc_1(socket, pwm_i, pwm_f, t_init, pre_time, ramp_time, sample_time):
    # 4, 5 and 5 samples before tx are fine (sample rate is 50ms), but 6 produces the
    # cleanest result without too much loose of temporal resolution
    modulotermico.config_adc(socket=socket, sbtx=6)
    modulotermico.set_pwm(socket, pwm_i)

    for i in range(0, int(pre_time/sample_time)):
        adc_val = modulotermico.get_adc(socket)
        telapsed = time.time() - t_init
        print "%s, %s, %s, %s [time, adc, pwm_i, pwm_f]" \
              % (telapsed, adc_val, pwm_i, pwm_f)
        time.sleep(sample_time)

    modulotermico.set_pwm(socket, pwm_f)

    for i in range(0, int(ramp_time/sample_time)):
        adc_val = modulotermico.get_adc(socket)
        telapsed = time.time() - t_init
        print "%s, %s, %s, %s [time, adc, pwm_i, pwm_f]"\
              % (telapsed, adc_val, pwm_i, pwm_f)
        time.sleep(sample_time)

    modulotermico.set_pwm(socket, pwm_i)


def ctrl_loop_adc_1(socket, delta_pwm, err_adc_val, t_init, adc_target):
    tloop_init = time.time() - t_init

    # read temp as adc_val
    adc_val = modulotermico.get_adc(socket)

    # execute Correction algorithm
    if adc_val > (adc_target + err_adc_val):
        ctrl_loop_adc_1.pwm += - delta_pwm
    elif adc_val < (adc_target - err_adc_val):
        ctrl_loop_adc_1.pwm += + delta_pwm

    debug_info = True
    if debug_info:
        # tloop = time.time() - (tloop_init + t_init)
        telapsed = time.time() - t_init
        print "%s, %s, %s, %s [time, adc, adc_target, pwm]"\
              % (telapsed, adc_val, adc_target, ctrl_loop_adc_1.pwm)

    return ctrl_loop_adc_1.pwm
ctrl_loop_adc_1.pwm = 1.0


def ctrl_loop_adc_2(socket, manual_pwm, pwm, t_init, target):
    tloop_init = time.time() - t_init

    # read temp as adc_val
    adc_val = modulotermico.get_adc(socket)

    # execute Correction algorithm
    delta_pwm = 0.7
    err_adc_val = 20.0
    if manual_pwm:
        ctrl_loop_adc_1.pwm = pwm
    if adc_val > (target + err_adc_val):
        ctrl_loop_adc_1.pwm += - delta_pwm
    elif adc_val < (target - err_adc_val):
        ctrl_loop_adc_1.pwm += + delta_pwm

    debug_info = True
    if debug_info:
        # tloop = time.time() - (tloop_init + t_init)
        telapsed = time.time() - t_init
        print "%s, %s, %s, %s [time, adc, target, pwm]"\
              % (telapsed, adc_val, target, ctrl_loop_adc_1.pwm)

    return ctrl_loop_adc_1.pwm
ctrl_loop_adc_1.pwm = 1.0


def ctrl_loop_adc_3(socket, manual_pwm, pwm, t_init, target):
    tloop_init = time.time() - t_init

    # read temp as adc_val
    adc_val = modulotermico.get_adc(socket)

    # if ctrl_type == "pid":
    #     pass
        # execute PID algorithm
        # global_PIDcontroller.target = target
        # pwmval = global_PIDcontroller.actualizar(calctemp)
        #print "Kp = ",
        #print global_PIDcontroller.Kp

    debug_info = True
    if debug_info:
        # tloop = time.time() - (tloop_init + t_init)
        telapsed = time.time() - t_init
        print "%s, %s, %s, %s [time, adc, target, pwm]"\
              % (telapsed, adc_val, target, ctrl_loop_adc_1.pwm)

    return ctrl_loop_adc_1.pwm
ctrl_loop_adc_1.pwm = 1.0

def get_ambtemp(socket):
    print "get_ambtemp"

    # puenteh_handler = rXbeeCS.PuentehHandlder(socket)
    # temp_algs = rXbeeCS.TempAlgs()

    #send pwm command
    pwm_value = 0.0
    modulotermico.set_pwm(socket, pwm_value)

    #send pwm command
    pwm_value = 0.0
    modulotermico.set_pwm(socket, pwm_value)

    #get current temp
    prev_calctemp = modulotermico.get_temp(socket)

    delta = 0.08
    curr_calctemp = 0.0

    elapsed_seconds = 0
    while True:
        time.sleep(3)
        elapsed_seconds += 3

        curr_calctemp = modulotermico.get_temp(socket)
        err = abs(prev_calctemp - curr_calctemp)

        print "curr_calctemp", curr_calctemp
        print "perv_calctemp", prev_calctemp

        print "err", err
        if err < delta:
            break
        prev_calctemp = curr_calctemp

        if elapsed_seconds >= 120:
            print "too long to get tempamb"
            break

    print "result", curr_calctemp
    return curr_calctemp


class AlgPID:
    """
    Control PID discreto
    """

    def __init__(self, p=2.0, i=0.0, d=1.0, derivador=0, integrador=0, integrador_max=3, integrador_min=-3):

        # Definición de los parámetros para el controlador PID
        self.Kp = p
        self.Ki = i
        self.Kd = d
        self.Derivador = float(derivador)
        self.Integrador = float(integrador)
        self.Integrador_max = integrador_max
        self.Integrador_min = integrador_min

        self.P_valor = 0
        self.D_valor = 0
        self.Integrador = 0
        self.I_valor = 0

        self.set_point = 0.0
        self.error = 0.0

    def actualizar(self, valor_actual):
        """
        Calcula el valor de la salida del PID dada una entrada de referencia y la realimentación
        """

        self.error = self.set_point - valor_actual

        self.P_valor = self.Kp * self.error
        self.D_valor = self.Kd * (self.error - self.Derivador)
        self.Derivador = self.error

        self.Integrador += + self.error

        # Límites para el parámetro Ki
        # Límite superior
        if self.Integrador > self.Integrador_max:
            self.Integrador = self.Integrador_max
        # Límite inferior
        elif self.Integrador < self.Integrador_min:
            self.Integrador = self.Integrador_min

        # Definición del parámetro I
        self.I_valor = self.Integrador * self.Ki

        # Función para el controlador
        pid = self.P_valor + self.I_valor + self.D_valor
        #print "PID = ",
        #print self.P_valor,
        ##print " + ",
        #print self.I_valor,
        #print " + ",
        #print self.D_valor

        # recortar entre 0.0 y 100.0
        # if (PID<0.0):
        #  	 PID=0.0
        # if (PID>100.0):
        #	 PID=100.0

        return pid

