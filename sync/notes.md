
if threshold is too high:
	When a device is restored it may come in before the expiration and since it's not in the current frame group so it gets added 

if threshold is too low:
	late frames will trigger new frame group and throw off sync


maybe a buffer of several frame groups


one frame group is made. the next frame group is made. If there are unexpected results in the next frame group things from that first one can be adjusted to the second. If things look ok then they first frame group is released the cycle repeats


	if sig.device is not in current group and time delta is below threshold
		add to current group


	else if 


could build up an expected log normal distro from past frames and use that to test the validity of new frame groups



The frame synchronizer will be able to release the first frame at a give time but only after analyzing several frames...



the distro will be affect the way frames are organized and the way frames are organized will affect the distro

the frames can selected by which distro yields the most consistent mean and lowest variance

