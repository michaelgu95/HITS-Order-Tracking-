package com.example.michaelgu.hits2;


import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.app.ActionBarDrawerToggle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.*;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.GridLayout;
import android.widget.GridLayout.LayoutParams;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import com.microsoft.onedrivesdk.saver.ISaver;
import com.microsoft.onedrivesdk.saver.Saver;
import com.microsoft.onedrivesdk.saver.SaverException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Calendar;

import static android.graphics.Color.parseColor;


public class PickupActivity extends ActionBarActivity {

    private static final String ONEDRIVE_APP_ID = "000000004C151DA2";
    public static final int PICK_FROM_GALLERY_REQUEST_CODE = 4;
    private ISaver mSaver;
    private TextView dateTextView;
    private File savedFileDirectory;
    private ListView mDrawerList;
    private ArrayAdapter<String> mAdapter;
    private ActionBarDrawerToggle mDrawerToggle;
    private DrawerLayout mDrawerLayout;
    private String mActivityTitle;
    private Calendar mCalendar;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pickup);

        //configure ListView for Side Navigation Drawer
        mDrawerList = (ListView)findViewById(R.id.navList);
        mDrawerLayout = (DrawerLayout)findViewById(R.id.drawer_layout);
        mActivityTitle = getTitle().toString();
        setupDrawer();
        addDrawerItems();

        //configure the actionbar
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(parseColor("#ED1C24")));
        getSupportActionBar().setTitle("");

        // Create the picker instance
        mSaver = Saver.createSaver(ONEDRIVE_APP_ID);

        // set click listeners
        findViewById(R.id.saveButton).setOnClickListener(mScreenShotListener);
        mDrawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent deliveryIntent = new Intent(PickupActivity.this, DeliveryActivity.class);
                startActivity(deliveryIntent);
            }
        });

        //create current Date and set on dateTextView
        configureDate();
    }

    private void setupDrawer(){
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.drawer_open, R.string.drawer_close) {

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                getSupportActionBar().setTitle("Options");
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                getSupportActionBar().setTitle(mActivityTitle);
                invalidateOptionsMenu();
            }
        };

        mDrawerToggle.setDrawerIndicatorEnabled(true);
        mDrawerLayout.setDrawerListener(mDrawerToggle);

    }

    private void addDrawerItems() {
        String[] osArray = { "Pickup", "Delivery" };
        mAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, osArray);
        mDrawerList.setAdapter(mAdapter);
    }

    private void configureDate(){
        dateTextView = (TextView) findViewById(R.id.date_holder);
        mCalendar = Calendar.getInstance();
        int year = mCalendar.get(Calendar.YEAR);
        int month = mCalendar.get(Calendar.MONTH);
        int day = mCalendar.get(Calendar.DAY_OF_MONTH);
        showDate(year, month + 1, day);
    }

    private void showDate(int year, int month, int day) {
        dateTextView.setText(new StringBuilder().append(month).append("/")
                .append(day).append("/").append(year));
    }

    public final View.OnClickListener mScreenShotListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            //format month correctly for database
            String month = Integer.toString(mCalendar.get(Calendar.MONTH) +1);
            if(mCalendar.get(Calendar.MONTH) < 9){
                month = "0" + month;
            }

            String date = Integer.toString(mCalendar.get(Calendar.DATE));
            if(mCalendar.get(Calendar.DATE)< 10){
                date = "0" + date;
            }

            uploadEmailAddress();

            //configure filename
            String fileName = ((EditText)findViewById(R.id.editPickupFrom)).getText().toString() + mCalendar.get(Calendar.YEAR) + month + date + ".png";

            // path to /data/data/yourapp/app_data/imageDir
            File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

            //prep for screenshot
            View rootView = view.getRootView();
            Bitmap bitmap = Bitmap.createBitmap(rootView.getMeasuredWidth(), rootView.getMeasuredHeight(), Bitmap.Config.RGB_565);
            Canvas screenShotCanvas = new Canvas(bitmap);
            rootView.draw(screenShotCanvas);

            OutputStream os = null;
            savedFileDirectory = new File(directory, fileName);

            try {
                os = new FileOutputStream(savedFileDirectory);
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, os);
                os.flush();
                os.close();

            } catch(FileNotFoundException e){
                e.printStackTrace();

            }catch(IOException e){
                e.printStackTrace();
            }
            mSaver.startSaving((Activity)view.getContext(), fileName, Uri.fromFile(savedFileDirectory));
        }
    };

    private void uploadEmailAddress(){
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                String fullURL = "https://docs.google.com/forms/d/1J2IxyopQe6ec_8mEp2lj101nPTPvUBiQu4WS98SmBn8/formResponse";
                HttpRequest req = new HttpRequest();

                EditText customerText = (EditText)findViewById(R.id.editPickupFrom);
                String customer = customerText.getText().toString();

                EditText emailText = (EditText)findViewById(R.id.editEmail);
                String emailAddress = emailText.getText().toString();

                String data = "entry_37742976=" + URLEncoder.encode(customer) + "&"
                        + "entry_830948319=" + URLEncoder.encode(emailAddress);
                String response = req.sendPost(fullURL, data);
            }
        });
        t.start();
    }


    private void sendMail(String path, String address) {
        Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
        emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL,
                new String[] { address });
        emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,
                "HITS Scanning Solutions - Pickup Receipt");
        emailIntent.putExtra(android.content.Intent.EXTRA_TEXT,
                "This is an autogenerated pickup receipt from HITS Scanning Solutions. \n\nPlease visit www.hitsscan.com for further information regarding our services. \n\nThank you for your business.");
        emailIntent.setType("image/jpg");
        Uri myUri = Uri.parse("file://" + path);
        emailIntent.putExtra(Intent.EXTRA_STREAM, myUri);
        startActivity(Intent.createChooser(emailIntent, "Send mail..."));
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        if(requestCode == mSaver.getRequestCode()) {

            try {
                mSaver.handleSave(requestCode, resultCode, data);
                EditText emailText = (EditText) findViewById(R.id.editEmail);
                sendMail(savedFileDirectory.toString(), emailText.getText().toString());

            } catch (final SaverException e) {
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

        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }

        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }
}
