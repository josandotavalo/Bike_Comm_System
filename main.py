import os, uuid, bluetooth
import logging, sys

logger = logging.Logger('catch_all')

# variables
host = ""
port = 1    # RPi usa el puerto 1 para comunicación Bluetooth
uuid = "94f39d29-7d6d-437d-973b-fba39e49d4ee"
blueFlag = True

while True:
    if blueFlag:
        # RPi puede ser descubierta por otros dispositivos Bluetooth
        os.system('sudo systemctl daemon-reload')
        os.system('sudo systemctl restart bluetooth')
        os.system('sudo sdptool add SP')
        os.system('sudo hciconfig hci0 piscan')

        # Creación del Socket Bluetooth RFCOMM communication
        server_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
        print('Bluetooth Socket Creado')

        try:
            server_sock.bind((host, port))
            print("Vinculación Bluetooth Completada")

            server_sock.listen(1) # Una conexion a la vez

            bluetooth.advertise_service(server_sock, "RPi", service_id = uuid)
            print("Esperando conexion Bluetooth...")
            client_sock, client_address = server_sock.accept()
            print(f"Conectado a {client_address}")

            blueFlag = False
        except:
            print("Vinculación Bluetooth Fallida")
            blueFlag = True

    try:
        while True:
            # se recive desde el smartphone
            data = client_sock.recv(1024) # 1024 is the buffer size.
            print(data)
            dataStr = data.decode()

            if dataStr == "1":
                os.system('nohup ./olsr_server.sh &')
                msg = "OLSR \n"
                client_sock.send(msg.encode())
            elif dataStr == "2":
                os.system('nohup ./batman_server.sh &')
                msg = "BATMAN \n"
                client_sock.send(msg.encode())
                #os.system('jobs &')
                #keyboard.press_and_release('ctrl+C')
            elif dataStr == "3":
                msg = "Reboot \n"
                client_sock.send(msg.encode())
                os.system('sudo reboot')
            else:
                msg = "Sin operación \n"
                # Sending the data.
                client_sock.send(send_data.encode())
    except KeyboardInterrupt:
        print ('KeyboardInterrupt exception is caught')
        sys.exit()
    except Exception as e:
        # Closing the client and server connection
        client_sock.close()
        server_sock.close()
        blueFlag = True
        logger.error(e, exc_info=True)

