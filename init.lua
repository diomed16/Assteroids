enemyOptions =
{
    frames =
    {
        {   -- frame 1
            x = 26,
            y = 40,
            width = 612,
            height = 360
			
			
        },
        {   -- frame 2
            x = 26,
            y = 399,
            width = 612,
            height = 360
        },
		{   -- frame 3
            x = 26,
            y = 767,
            width = 612,
            height = 360
        },
		{   -- frame 4
            x = 26,
            y = 1133,
            width = 612,
            height = 360
        }
    }
}

sequenceData =
{
{
    name="normal",
    start=1,
    count=1,
    time=100,
    loopCount = 10,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	},
	{
    name="damage1",
    start=2,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage2",
    start=3,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage3",
    start=4,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
}




hpOptions =
{
    frames =
    {
        {   -- frame 1
            x = 168,
            y = 5208,
            width = 1902,
            height = 530
			
			
        },
        {   -- frame 2
            x = 166,
            y = 4498,
            width = 1902,
            height = 530
        },
		{   -- frame 3
            x = 164,
            y = 3786,
            width = 1902,
            height = 530
        },
		{   -- frame 4
            x = 163,
            y = 3070,
            width = 1902,
            height = 530
        },
		{   -- frame 5
            x = 160,
            y = 2360,
            width = 1902,
            height = 530
        }		,
		{   -- frame 6
            x = 156,
            y = 1646,
            width = 1902,
            height = 530
        }
			,
		{   -- frame 7
            x = 2579,
            y = 2807,
            width = 2031,
            height = 630
        }
    }
}

hpData =
{
{
    name="normal",
    start=1,
    count=1,
    time=100,
    loopCount = 10,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	},
	{
    name="damage1",
    start=2,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage2",
    start=3,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage3",
    start=4,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage4",
    start=5,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage5",
    start=6,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
	,
	{
    name="damage0",
    start=7,
    count=1,
    time=100,
    loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
    loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
	}
}