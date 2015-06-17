package com.example.michaelgu.hits2;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.*;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.GridLayout;
import android.widget.GridLayout.LayoutParams;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.microsoft.onedrivesdk.saver.ISaver;
import com.microsoft.onedrivesdk.saver.Saver;
import com.microsoft.onedrivesdk.saver.SaverException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Calendar;


public class PickupActivity extends ActionBarActivity {

    private TextView dateTextView;
    private ISaver mSaver;
    private static final String ONEDRIVE_APP_ID = "000000004C151DA2";
    public static final int PICK_FROM_GALLERY_REQUEST_CODE = 4;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pickup);

        // Create the picker instance
        mSaver = Saver.createSaver(ONEDRIVE_APP_ID);

        // Add the on click listener
        findViewById(R.id.saveButton).setOnClickListener(mScreenShotListener);

        //set current Date on dateTextView
        dateTextView = (TextView) findViewById(R.id.date_holder);
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        showDate(year, month + 1, day);

    }

    private void showDate(int year, int month, int day) {
        dateTextView.setText(new StringBuilder().append(month).append("/")
                .append(day).append("/").append(year));
    }

    public final View.OnClickListener mScreenShotListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            String fileName = ((EditText)findViewById(R.id.editPickupFrom)).getText().toString() ;

            // path to /data/data/yourapp/app_data/imageDir
            File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);



            View rootView = view.getRootView();
            Bitmap bitmap = Bitmap.createBitmap(rootView.getMeasuredWidth(), rootView.getMeasuredHeight(), Bitmap.Config.RGB_565);
            Canvas screenShotCanvas = new Canvas(bitmap);
            rootView.draw(screenShotCanvas);

            OutputStream os = null;
            File imageFile = new File(directory, fileName);

            try {
                os = new FileOutputStream(imageFile);
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                os.flush();
                os.close();

            } catch(FileNotFoundException e){
                e.printStackTrace();

            }catch(IOException e){
                e.printStackTrace();
            }

            mSaver.startSaving((Activity)view.getContext(), fileName, Uri.fromFile(imageFile));
        }
    };



    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        if(requestCode == mSaver.getRequestCode()) {

            try {
                mSaver.handleSave(requestCode, resultCode, data);
            } catch (final SaverException e) {
            }
        } else if(requestCode == PICK_FROM_GALLERY_REQUEST_CODE) {
            saveFileToDrive(data.getData(), this);
            System.out.println(Environment.getExternalStorageDirectory().toString());
            System.out.println(data.getData());
        } else {
            Log.e(getClass().getSimpleName(), "Unable to resolve onActivityResult request code " + requestCode);
        }
    }

    private void saveFileToDrive(final Uri data, final Activity activity) {
        new AsyncTask<Void, Void, Void>(){
            @Override
            protected Void doInBackground(final Void... voids) {
                // Create URI from real path
                final String path = getPathFromUri(data);

                mSaver.startSaving(activity, path, Uri.parse(data.toString()));
                return null;
            }
        }.execute((Void) null);
    }

    /**
     * Gets the path from a URI
     * @param uri The uri fro the item to look up its full path
     * @return The path
     */
    private String getPathFromUri(final Uri uri)
    {
        final String[] projection = { MediaStore.Images.Media.DATA };
        Cursor cursor = null;
        try {
            cursor = getContentResolver().query(uri, projection, null, null, null);
            final int data_column = cursor
                    .getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(data_column);
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_pickup, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

}
