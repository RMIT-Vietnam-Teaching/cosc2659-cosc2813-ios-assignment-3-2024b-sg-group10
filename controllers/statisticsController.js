const Report = require("../models/Report");
const moment = require("moment");

exports.getStatistics = async (req, res) => {
  try {
    // Statistics of number of reports by type
    const reportStatsByType = await Report.aggregate([
      { $group: { _id: "$type", count: { $sum: 1 } } },
    ]);

    // User activity statistics over time
    const userActivityStats = await Report.aggregate([
      { $group: { _id: "$user", count: { $sum: 1 } } },
      {
        $lookup: {
          from: "users",
          localField: "_id",
          foreignField: "_id",
          as: "user",
        },
      },
      { $unwind: "$user" },
      { $project: { _id: 0, user: "$user.name", reports: "$count" } },
    ]);

    const { timeFrame } = req.query;

    let startDate;

    if (timeFrame === "day") {
      startDate = moment().startOf("day");
    } else if (timeFrame === "week") {
      startDate = moment().startOf("week");
    } else if (timeFrame === "month") {
      startDate = moment().startOf("month");
    } else {
      return res.status(400).json({ message: "Invalid time frame" });
    }

    const reportStatsByTime = await Report.countDocuments({
      createdAt: { $gte: startDate.toDate() },
    });

    // Trả về tất cả các thống kê trong một response
    res.status(200).json({
      reportStatsByType,
      userActivityStats,
      reportStatsByTime: {
        timeFrame,
        count: reportStatsByTime,
      },
    });
  } catch (error) {
    res.status(500).json({ message: "Failed to get statistics", error });
  }
};
