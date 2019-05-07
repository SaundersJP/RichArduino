/*A lot of modified code from: https://www.instructables.com/id/Android-Bluetooth-Control-LED-Part-2/*/

package com.bluetooth.bluetooth;

import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.text.InputType;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.os.AsyncTask;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

public class ledControl extends AppCompatActivity {

    Button btnClr;
    Button btnDis;
    EditText editText;
    String address = null;
    private ProgressDialog progress;
    BluetoothAdapter myBluetooth = null;
    BluetoothSocket btSocket = null;
    private boolean isBtConnected = false;
    static final UUID myUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

    private ConnectedThread mConnectedThread;

    Handler h;
    final int RECIEVE_MESSAGE = 1;
    private StringBuilder sb = new StringBuilder();
    private int received=0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_led_control);

        //receive the address of the bluetooth device
        Intent newint = getIntent();
        address = newint.getStringExtra("EXTRA_ADDRESS");

        setContentView(R.layout.activity_led_control);

        new ConnectBT().execute();

        editText = findViewById(R.id.simpleEditText);
        editText.setRawInputType(InputType.TYPE_CLASS_TEXT);
        editText.setImeOptions(EditorInfo.IME_ACTION_GO);
        editText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;
                if (actionId == EditorInfo.IME_ACTION_GO) {

                    ReceiveData runner = new ReceiveData();
                    runner.execute(editText);
                    handled = true;

                }
                return handled;
            }
        });


        btnClr = findViewById(R.id.button_clear);
        btnClr.setOnClickListener(new View.OnClickListener()
        {
           @Override
           public void onClick(View v)
           {
                Clear();
           }
        });

        btnDis = findViewById(R.id.button_disconnect);

        btnDis.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                Disconnect(); //close connection
            }
        });
    }

    private byte[] dealWithMsg(EditText text){
        String word = text.getText().toString().trim();
        if(word.length()==0){
            Toast.makeText(getApplicationContext(), "Invalid Command", Toast.LENGTH_LONG).show();
            editText.setText("");
        }
        if(word.length() >77){
            word = word.substring(0,76);
        }
        word = "m" + (char) word.length() + word;

        return word.getBytes();
    }

    private void Clear()
    {
        String c = "c";
        byte[] cByte = c.getBytes();
        mConnectedThread.sendMessage(cByte[0]);
    }


    private void Disconnect()
    {
        if (btSocket!=null) //If the btSocket is busy
        {
            try
            {
                btSocket.close(); //close connection
            }
            catch (IOException e)
            { Toast.makeText(getApplicationContext(),"Error",Toast.LENGTH_LONG).show();}
        }
        finish(); //return to the first layout
    }


    private class ConnectedThread extends Thread {
        private final InputStream mmInStream;
        private final OutputStream mmOutStream;

        public ConnectedThread(BluetoothSocket socket) {
            InputStream tmpIn = null;
            OutputStream tmpOut = null;

            // Get the input and output streams, using temp objects because
            // member streams are final
            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) { }

            mmInStream = tmpIn;
            mmOutStream = tmpOut;
        }

        public int receiveMsg() {
            byte[] buffer = new byte[1024];  // buffer store for the stream
            Integer bytes; // bytes returned from read()

            // Keep listening to the InputStream until an exception occurs
            while (true) {
                try {
                    // Read from the InputStream
                    bytes = mmInStream.read(buffer);

                    if(bytes == 1) {
                        return 1;
                    }

                } catch (IOException e) {
                    break;
                }
            }
            return 0;
        }

        private void sendMessage(byte word) {

            //send over word
            if (btSocket!=null)
            {
                try
                {
                    String a = ""+word;
                    mmOutStream.write(word);

                }
                catch (IOException e)
                {
                    Toast.makeText(getApplicationContext(),"Error",Toast.LENGTH_LONG).show();
                }
            }


        }

    }

    private class ReceiveData extends AsyncTask<EditText, Integer, Integer>{
        @Override
        protected Integer doInBackground(EditText... thing){
            byte[] toBeSent = dealWithMsg(thing[0]);
            Integer x = 0;
            String length = "" + toBeSent.length;
            for(int i = 0; i < toBeSent.length; i++){
                byte b = toBeSent[i];
                if(i>1) {
                    if (((char) b > 126) || ((char) b < 32)) {
                        b=(byte)32;
                    }
                }
                mConnectedThread.sendMessage(b);
                x = mConnectedThread.receiveMsg();

                while(x!=1){
                    //do nothing
                }
            }
            return x;
        }

        @Override
        protected void onProgressUpdate(Integer... values) {
            super.onProgressUpdate(values);
        }

        @Override
        protected void onPostExecute(Integer result) {
            if(result == 1){
                Toast.makeText(getApplicationContext(),"receive ", Toast.LENGTH_LONG).show();
            }
            super.onPostExecute(result);
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
    }


    private class ConnectBT extends AsyncTask<Void, Void, Void>  // UI thread
    {
        private boolean ConnectSuccess = true; //if it's here, it's almost connected

        @Override
        protected void onPreExecute()
        {
            progress = ProgressDialog.show(ledControl.this, "Connecting...", "Please wait!!!");  //show a progress dialog
        }

        @Override
        protected Void doInBackground(Void... devices) //while the progress dialog is shown, the connection is done in background
        {
            Log.d("DEBUG","TESTING");
            try
            {
                if (btSocket == null || !isBtConnected)
                {
                    Log.d("DEBUG","TESTING");
                    myBluetooth = BluetoothAdapter.getDefaultAdapter();//get the mobile bluetooth device
                    BluetoothDevice dispositivo = myBluetooth.getRemoteDevice(address);//connects to the device's address and checks if it's available
                    btSocket = dispositivo.createInsecureRfcommSocketToServiceRecord(myUUID);//create a RFCOMM (SPP) connection
                    BluetoothAdapter.getDefaultAdapter().cancelDiscovery();
                    btSocket.connect();//start connection
                }
            }
            catch (IOException e)
            {
                ConnectSuccess = false;//if the try failed, you can check the exception here
            }
            return null;
        }
        @Override
        protected void onPostExecute(Void result) //after the doInBackground, it checks if everything went fine
        {
            super.onPostExecute(result);

            if (!ConnectSuccess)
            {
                Toast.makeText(getApplicationContext(),"Connection Failed. Is it a SPP Bluetooth? Try again.",Toast.LENGTH_LONG).show();
                finish();
            }
            else
            {
                Toast.makeText(getApplicationContext(),"Connected.",Toast.LENGTH_LONG).show();
                isBtConnected = true;
            }
            progress.dismiss();
            mConnectedThread = new ConnectedThread(btSocket);
            mConnectedThread.start();
        }
    }

}