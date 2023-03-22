Emotiv Operating Procedures
By John Thorp
02/07/18

And now for the main course, a hearty helping of Emotiv EPOC+ served on a bed of this-thing-is-kinda-hard-to-deal-with with a side of maybe-pay-for-a-better-headset.

Hardware

The Emotiv EPOC+ is the wacky looking headset. It charges via the USB cable, and connects to the computer via a USB dongle. One constant light and another blinking means the computer cannot connect to the headset, two constant lights means you are connected.

The electrodes, known to the common folk as 'little cylinders of felt' are located in the Emotiv-labeled case.

Consistent electrode saturation is imperative to proper headset operation. Using the Bausch and Lomb re-nu sensitive gentle formula (I don't know how to make that seem like a real product name), add 8 to 9 drops to the electrodes, or until the saline solution seems to linger at the top for a moment longer (science).

Software / Code

Open EmotivPro at the beginning of the task, available from the Downloads page of the Emotiv website after using your Emotiv ID and password.

EmotivPro should display some lovely suggestions concerning wearing the headset.

Next, EmotivPro will show you what electrodes are properly making contact with the scalp. Rub the reference electrodes around (located right above the ear) until they make contact, then wrestle around with the rest. 
  There's not a perfect technique for this.
  If one of them refuses to work you can take it out, wet it, and place it back in.
  Gentle, consistent pressure that you slowly release is the best way to keep it connected

Once all of the electrodes are making contact, you can begin your task!


Software requirements

Emotiv SDK in your Matlab root folder, available here: https://github.com/Emotiv/community-sdk

Running ActivateLicense on the computer about once a month

As of this writing:
32-bit Matlab running Microsoft Visual Studio 2010 and Psychtoolbox 3.0.11
	ItÕs not just you, this is all weird.

Matlab 2015b, 32-bit (2015b on Windows): https://www.mathworks.com/login?uri=https%3A%2F%2Fwww.mathworks.com%2Fdownloads%2Fweb_downloads%2Fselect_release%3Fmode%3Dgwylf

Microsoft Visual Studio 2010: https://my.visualstudio.com/Downloads?q=visual%20studio%202010&wt.mc_id=o~msft~vscom~older-downloads
I had luck logging in with my institution credentials and downloading '[Trial] Visual Studio 2010 Professional'. As far as I'm aware, this trial does not run out.
Then in Matlab you'll need to run 
      mex -setup
      and click on Microsoft Visual Studio 2010 (it should be there)
      
	Psychtoolbox 3.0.11:
		Follow all instructions as normal on http://psychtoolbox.org/download/#Windows
		But call DownloadPsychtoolbox with flavor 'Psychtoolbox 3.0.11'
		Should look like DownloadPsychtoolbox('toolbox','Psychtoolbox 3.0.11')

General Rules

The Emotiv headset has a command called 'IEE_EngineDisconnect' that has to be called after the recording session is over, or the rest of the data that comes in will be corrupted. This means that if the task quits or errors before getting to the end, the easiest thing to do is quit Matlab and open it again.

Your task should have an emotiv_setup script, which will create all the necessary variables, an emotiv_collect function that has each necessary variable as an input, and an emotiv_save function that will finalize the task and disconnect from the engine.
